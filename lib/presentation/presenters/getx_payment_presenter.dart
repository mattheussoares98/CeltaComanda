import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../data/models/models.dart';
import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
import '../../infra/helpers/helpers.dart';
import '../../main/builders/builders.dart';
import '../../presentation/mixins/mixins.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';
import '../protocols/protocols.dart';

class GetxPaymentPresenter extends GetxController
    with LoadingManager, UIErrorManager
    implements PaymentPresenter {
  final Pay pay;
  final CommandInformations commandInformations;
  final ConcFinishSaleRequest finishSaleRequestConcentrador;
  final NavigateTo navigateTo;
  final UpdateSaleRequest updateSaleRequest;
  final LoadCustomer loadCustomer;
  final Validation validation;
  final CovenantLimit covenantLimit;
  final CheckPasswordByCustomerCode checkPasswordByCustomerCode;
  final ConcInsertSaleMovement concInsertSaleMovement;
  final GenerateXmlForNfce generateXmlForNfce;
  final SendSaleMovementAsNfce sendSaleMovementAsNfce;
  final CouponFiscalNumber couponFiscalNumber;

  GetxPaymentPresenter({
    required this.pay,
    required this.commandInformations,
    required this.finishSaleRequestConcentrador,
    required this.navigateTo,
    required this.updateSaleRequest,
    required this.loadCustomer,
    required this.validation,
    required this.covenantLimit,
    required this.checkPasswordByCustomerCode,
    required this.concInsertSaleMovement,
    required this.generateXmlForNfce,
    required this.sendSaleMovementAsNfce,
    required this.couponFiscalNumber,
  });

  @override
  Future<void> callPayment({
    required double longAmountValue,
    required int portionQuantity,
    required PaymentMode paymentMode,
    required HomePresenter homePresenter,
  }) async {
    mainError = null;
    isLoading = true;
    try {
      _lastRequestedPaymentFinalization = ConcentratorFinalizationModel(
        FinalizationId: paymentMode.finalizationId,
        Value: longAmountValue,
        ValueLiquid: longAmountValue,
        PortionQuantity: 1,
      );

      bool isValid = await commandInformations.isValidDatetime(
        commandNumber: homePresenter.commandEntity!.commandNumber!,
      );

      if (!isValid) {
        throw DomainError.blockedCommand;
      }

      await pay.pay(
        paymentMode: paymentMode,
        channel: homePresenter.isGeneratingVersionToRede
            ? Channels.rede
            : Channels.getnet,
        params: PayParams(
          longAmountValue: (longAmountValue * 100).toInt(),
          portionQuantity: portionQuantity,
        ),
      );
    } on DomainError catch (e) {
      switch (e) {
        case DomainError.blockedCommand:
          mainError = UIError.blockedCommand;
        default:
          mainError = UIError.unexpected;
      }
    } finally {
      isLoading = false;
    }
  }

  @override
  Future<void> liquidateCommand({
    required HomePresenter homePresenter,
    required PrintedProductsPresenter printedProductsPresenter,
    required void Function() showSuccessAndCloseUntilHomePage,
  }) async {
    updateScreen = true;

    if (_lastRequestedPaymentFinalization != null &&
        !_successfulPayments.contains(_lastRequestedPaymentFinalization)) {
      _successfulPayments.add(_lastRequestedPaymentFinalization!);
    }
    updateScreen = false;

    if (totalPaidValue <
        printedProductsPresenter
            .getTotalLiquid(printedProductsPresenter.printed)) {
      return;
    }

    mainError = null;
    isLoading = true;
    try {
      await finishSaleRequestConcentrador.finish(
        pdvNumber: homePresenter.commandEntity?.pdv?.PdvNumber == null
            ? 100
            : homePresenter.commandEntity!.pdv!.PdvNumber!.toInt(),
        commandNumber: homePresenter.commandEntity!.commandNumber!.toInt(),
        finalizations: _successfulPayments,
      );

      _successfulPayments.clear();
      showSuccessAndCloseUntilHomePage();
      _lastRequestedPaymentFinalization = null;
      await printedProductsPresenter.loadPrinted(
        homePresenter.commandEntity!.commandNumber!,
      );
    } catch (e) {
      mainError = UIError.unexpected;
    } finally {
      isLoading = false;
    }
  }

  MethodChannel? _channel;
  @override
  void initPaymentResultHandler({
    required HomePresenter homePresenter,
    required PrintedProductsPresenter printedProductsPresenter,
    required void Function() showSuccessAndCloseUntilHomePage,
  }) {
    if (homePresenter.isGeneratingVersionToGetNet) {
      _channel = MethodChannel(Channels.getnet.name);
    } else if (homePresenter.isGeneratingVersionToRede) {
      _channel = MethodChannel(Channels.rede.name);
    } else {
      return;
    }

    _channel?.setMethodCallHandler((MethodCall call) async {
      if (homePresenter.isGeneratingVersionToRede) {
        await _treatRedeResponse(
          homePresenter,
          printedProductsPresenter,
          call,
          showSuccessAndCloseUntilHomePage,
        );
      } else {
        await _treatGetNetResponse(
          homePresenter,
          printedProductsPresenter,
          call,
          showSuccessAndCloseUntilHomePage,
        );
      }
    });
  }

  Future<void> _treatGetNetResponse(
    HomePresenter homePresenter,
    PrintedProductsPresenter printedProductsPresenter,
    MethodCall call,
    void Function() showSuccessAndCloseUntilHomePage,
  ) async {
    try {
      final response = GetNetResponseModel.fromJson(call.arguments);
      if (response.result == "0") {
        await liquidateCommand(
          homePresenter: homePresenter,
          printedProductsPresenter: printedProductsPresenter,
          showSuccessAndCloseUntilHomePage: showSuccessAndCloseUntilHomePage,
        );
      } else if (response.result == "1") {
        mainError = UIError.paymentDeclined;
      } else if (response.result == "2") {
        mainError = UIError.paymentCanceled;
      } else if (response.result == "3") {
        mainError = UIError.paymentFailed;
      } else if (response.result == "4") {
        mainError = UIError.paymentUnexpectedError;
      } else if (response.result == "5") {
        mainError = UIError.paymentPendant;
      } else {
        mainError = UIError.paymentUnexpectedError;
      }
    } catch (e) {
      mainError = UIError.unexpected;
    }
  }

  Future<void> _treatRedeResponse(
    HomePresenter homePresenter,
    PrintedProductsPresenter printedProductsPresenter,
    MethodCall call,
    void Function() showSuccessAndCloseUntilHomePage,
  ) async {
    if (call.arguments == "Pagamento Autorizado") {
      try {
        await liquidateCommand(
          homePresenter: homePresenter,
          printedProductsPresenter: printedProductsPresenter,
          showSuccessAndCloseUntilHomePage: showSuccessAndCloseUntilHomePage,
        );
      } catch (e) {
        mainError = UIError.liquidadeCommandError;
      }
    } else if (call.arguments == "Pagamento Falhou") {
      mainError = UIError.paymentFailed;
    } else if (call.arguments == "Pagamento cancelado") {
      mainError = UIError.paymentCanceled;
    } else if (call.arguments == "Pagamento Recusado") {
      mainError = UIError.paymentDeclined;
    } else {
      mainError = UIError.paymentUnexpectedError;
    }
  }

  @override
  void disposePaymentResultHandler() {
    _channel?.setMethodCallHandler(null);
  }

  @override
  void goToCovenantPage() {
    navigateTo.navigate(pageRoute: PageRoutes.covenant);
  }

  @override
  double get totalPaidValue {
    if (_successfulPayments.isEmpty) {
      return 0;
    } else {
      return _successfulPayments.fold(
          0.0, (previousValue, element) => previousValue + element.Value!);
    }
  }

  @override
  double getTotalPendingValue(
    PrintedProductsPresenter printedProductsPresenter,
  ) {
    double totalLiquid = printedProductsPresenter
        .getTotalLiquid(printedProductsPresenter.printed);

    return (totalLiquid - totalPaidValue);
  }

  @override
  Future<void> getCustomerByNameCodeOrCpf({
    required String value,
    required void Function(String error) showErrorMessageReturnedByBs,
    required bool searchByPersonalizedCode,
  }) async {
    mainError = null;
    isLoading = true;
    customersViewModel = null;
    _selectedCovenant = {};

    try {
      validateCustomerField(value);

      _authorizationPendingModel = null;

      int? valueInInt = int.tryParse(value);

      SoapResponse? soapResponse;

// 1=ExactCnpjCpfNumber
// 2=ExactCode
// 3=ApproximateName
// 4=PersonalizedCode
      if (value.isEmpty) {
        return;
      } else if (valueInInt == null) {
        soapResponse = await loadCustomer.load(
          value: value,
          searchTypeInt: 3,
        );
      } else if (searchByPersonalizedCode) {
        soapResponse = await loadCustomer.load(
          value: value,
          searchTypeInt: 4,
        );
      } else if (valueInInt.toString().length == 11 ||
          valueInInt.toString().length == 14) {
        soapResponse = await loadCustomer.load(
          value: value,
          searchTypeInt: 1,
        );
      } else {
        soapResponse = await loadCustomer.load(
          value: value,
          searchTypeInt: 2,
        );
      }

      if (soapResponse.responseType == SoapResponseType.error) {
        showErrorMessageReturnedByBs(soapResponse.response);
      } else {
        customersViewModel = json
            .decode(soapResponse.response)
            .map((e) => CustomerViewModel.fromJson(e))
            .toList()
            .cast<CustomerViewModel>();
      }
    } catch (e) {
      mainError = UIError.unexpected;
    } finally {
      isLoading = false;
    }
  }

  @override
  void validateCustomerField(String value) {
    customerError = null;
    const field = "customer";

    final formData = {field: value};
    customerError = validation.validate(field: field, input: formData);

    if (value.isEmpty) {
      customerError = ValidationError.requiredField;
    }
  }

  @override
  Future<void> updateSelectedCovenant(
    CustomerViewModel? customer,
    String? covenantCode,
  ) async {
    _authorizationPendingModel = null;

    if (customer == null) {
      _selectedCovenant = {};
    } else {
      _selectedCovenant = {
        customer.Code!: covenantCode,
      };
    }
  }

  @override
  Future<void> finishSaleRequestByCovenant({
    required HomePresenter homePresenter,
    required PrintedProductsPresenter printedProductsPresenter,
    required void Function(String error) showErrorMessageReturnedByBs,
    required void Function() showSuccessAndCloseUntilHomePage,
    required String? customerPassword,
    required int? cpf,
    required int? cnpj, //TODO use only one. Or cnpj or cpf
  }) async {
    mainError = null;
    isLoading = true;
    try {
      if (customerPassword != null && customerPassword.isNotEmpty) {
        final passwordResponse = await checkPasswordByCustomerCode.validate(
          customerCode: _selectedCovenant.keys.first.toInt(),
          password: customerPassword,
        );
        if (passwordResponse.responseType == SoapResponseType.error) {
          showErrorMessageReturnedByBs(passwordResponse.response);
          return;
        }
      }

      double pendingValue = getTotalPendingValue(printedProductsPresenter);

      SoapResponse soapResponse = await covenantLimit
          .authorizeCovenantLimitUseByCodeAndGetAuthorizeCode(
        crossIdentity: EnterpriseBuilder.entity!
            .enterpriseConcentradorParametersEntity?.celtaBSCrossIdentity,
        customerCode: _selectedCovenant.keys.first.toInt(),
        covenantCode: _selectedCovenant.values.first!.toInt(),
        value: pendingValue,
      );

      if (soapResponse.responseType == SoapResponseType.error) {
        showErrorMessageReturnedByBs(soapResponse.response);
      } else {
        _authorizationPendingModel = AuthorizationPendingModel(
          code: soapResponse.response,
          isPending: true,
        );

        _successfulPayments.add(ConcentratorFinalizationModel(
          FinalizationId: FinalizationType.covenant.id,
          Value: pendingValue,
          ValueLiquid: pendingValue,
          PortionQuantity: 1,
          AuthorizationCode: soapResponse.response,
          AuthorizationType: 2,
        ));

        if (_couponNumber == null) {
          _couponNumber = await couponFiscalNumber.loadLastNumber() + 1;
        } else {
          _couponNumber = _couponNumber! + 1;
        }

        if (_couponNumber == null) {
          throw Exception();
        }

        //TODO generate totalSharing configuration. If isnt fiscal, dont send xml
        final xml = await generateXmlForNfce.generate(
          couponFiscalNumber: _couponNumber!,
          products: printedProductsPresenter.printed?.Products
                  .map((e) => e.toEntity())
                  .toList() ??
              [],
          finalizations: _successfulPayments,
          customer: null,
          cpf: cpf,
          cnpj: cnpj,
          pdvNumber: homePresenter.commandEntity?.pdv?.PdvNumber?.toInt(),
          incrementValue: printedProductsPresenter.getServiceChargeValue(
            printedProductsPresenter.printed,
          ),
        );

        final xmlReponse = await sendSaleMovementAsNfce.send(xml);

        if (xmlReponse.responseType == SoapResponseType.error) {
          showErrorMessageReturnedByBs(xmlReponse.response);
          return;
        }

        final double serviceChargeValue = printedProductsPresenter
            .getServiceChargeValue(printedProductsPresenter.printed);

        await concInsertSaleMovement.insert(
          couponFiscalNumber: _couponNumber!,
          pdvId: homePresenter.commandEntity!.pdv!.PdvId!,
          pdvNumber: homePresenter.commandEntity!.pdv!.PdvNumber!,
          covenantCode: _selectedCovenant.values.isEmpty
              ? null
              : _selectedCovenant.values.first?.toInt(),
          customerCode: _selectedCovenant.keys.isEmpty
              ? null
              : _selectedCovenant.keys.first.toInt(),
          cpfCnpj: cpf != null ? cpf.toString() : cnpj?.toString(),
          incrementType: serviceChargeValue == 0 ? 0 : 1,
          incrementValue: serviceChargeValue,
          totalLiquid: printedProductsPresenter
              .getTotalLiquid(printedProductsPresenter.printed),
          finalizations: _successfulPayments.map((e) => e.toEntity()).toList(),
          products: printedProductsPresenter.printed!.Products,
          xmlToGenerateFiscal:
              xmlReponse.response, //TODO if doesnt fiscal, send null value
        );

        await couponFiscalNumber.save(_couponNumber!);

        _authorizationPendingModel = null;
        _successfulPayments.clear();
        showSuccessAndCloseUntilHomePage();
        //TODO exclude salerequest
        await printedProductsPresenter
            .loadPrinted(homePresenter.commandEntity!.commandNumber!);
      }
    } catch (e) {
      mainError = UIError.unexpected;
    } finally {
      isLoading = false;
    }
  }

  @override
  void clearPayments() {
    _lastRequestedPaymentFinalization = null;
    _successfulPayments.clear();
  }

  ConcentratorFinalizationModel? _lastRequestedPaymentFinalization;
  @override
  ConcentratorFinalizationModel? get lastRequestedPaymentFinalization =>
      _lastRequestedPaymentFinalization;

  final _updateScreenStream = Rx<bool>(false);
  @override
  Stream<bool> get updateScreenStream => _updateScreenStream.stream;
  set updateScreen(bool value) => _updateScreenStream.value = value;

  final List<ConcentratorFinalizationModel> _successfulPayments = [];
  @override
  List<ConcentratorFinalizationModel> get successfulPayments =>
      _successfulPayments;

  final _customerError = Rx<ValidationError?>(null);
  @override
  Stream<ValidationError?> get customerErrorStream => _customerError.stream;
  set customerError(ValidationError? value) => _customerError.value = value;

  final _customersViewModel = Rx<List<CustomerViewModel>?>(null);
  @override
  Stream<List<CustomerViewModel>?> get customersViewModelStream =>
      _customersViewModel.stream;
  set customersViewModel(List<CustomerViewModel>? customer) =>
      _customersViewModel.subject.add(customer);

  Map<String, String?> _selectedCovenant = {};
  @override
  Map<String, String?> get selectedCovenant => _selectedCovenant;

  AuthorizationPendingModel? _authorizationPendingModel;

  @override
  AuthorizationPendingModel? get authorizationPendingModel =>
      _authorizationPendingModel;

  int? _couponNumber;
  @override
  int? get couponNumber => _couponNumber;
}
