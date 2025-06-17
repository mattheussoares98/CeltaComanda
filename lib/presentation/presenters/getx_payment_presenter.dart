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
    with LoadingManager, UIErrorManager, ErrorHandling
    implements PaymentPresenter {
  final RedePay redePay;
  final GetnetPay getnetPay;
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
  final LoadUseUrlSatSharing loadUseUrlSatSharing;
  final DeleteSaleRequest deleteSaleRequest;
  final ValidateCpfCnpj validateCpfCnpj;

  GetxPaymentPresenter({
    required this.redePay,
    required this.getnetPay,
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
    required this.loadUseUrlSatSharing,
    required this.deleteSaleRequest,
    required this.validateCpfCnpj,
  });

  @override
  Future<void> callPayment({
    required double longAmountValue,
    required int portionQuantity,
    required PaymentMode paymentMode,
    required HomePresenter homePresenter,
    required PrintedProductsPresenter printedProductsPresenter,
    required void Function() showSuccessAndCloseUntilHomePage,
    required void Function(String error) showErrorMessageReturnedByBs,
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

      if (homePresenter.isGeneratingVersionToRede) {
        await redePay.pay(
          PayParamsModel(
            longAmountValue: (longAmountValue * 100).toInt(),
            portionQuantity: portionQuantity,
            paymentMode: paymentMode,
          ),
        );
      } else if (homePresenter.isGeneratingVersionToGetNet) {
        final result = await getnetPay.pay(
          PayParamsModel(
            longAmountValue: (longAmountValue * 100).toInt(),
            portionQuantity: portionQuantity,
            paymentMode: paymentMode,
          ),
        );

        await _treatGetNetResponse(
          homePresenter,
          result,
          printedProductsPresenter,
          showSuccessAndCloseUntilHomePage,
          showErrorMessageReturnedByBs,
        );
        isLoading = false;
      }
    } catch (e) {
      mainError = getUIError(e);
      isLoading = false;
    } finally {
      Future.delayed(Duration(seconds: 20), () {
        isLoading = false;
      });
    }
  }

  @override
  Future<void> liquidateCommand({
    required HomePresenter homePresenter,
    required PrintedProductsPresenter printedProductsPresenter,
    required void Function() showSuccessAndCloseUntilHomePage,
    required void Function(String error) showErrorMessageReturnedByBs,
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
      bool useSharing = loadUseUrlSatSharing.getUse(_cpfCnpj);
      SoapResponse? xmlReponse;

      _couponNumber = await couponFiscalNumber.loadLastNumber();
      final newCouponNumber =
          _couponNumber! + 1; //change the _coupomNumber only after succeeds

      if (useSharing == false) {
        final xml = await generateXmlForNfce.generate(
          couponFiscalNumber: newCouponNumber,
          printed: PrintedModel.fromViewModel(printedProductsPresenter.printed!)
              .toEntity(),
          finalizations: _successfulPayments,
          customer: _selectedCustomer?.customer.toEntity(),
          cpfCnpj: _cpfCnpj,
          pdvNumber: homePresenter.commandEntity?.pdv?.PdvNumber?.toInt(),
          incrementValue: printedProductsPresenter.getServiceChargeValue(
            printedProductsPresenter.printed,
          ),
        );

        xmlReponse = await sendSaleMovementAsNfce.send(xml);

        if (xmlReponse.responseType == SoapResponseType.error) {
          showErrorMessageReturnedByBs(xmlReponse.response);
          return;
        }
      }

      final double serviceChargeValue = printedProductsPresenter
          .getServiceChargeValue(printedProductsPresenter.printed);

      await concInsertSaleMovement.insert(
        commandNumber: homePresenter.commandEntity!.commandNumber!.toInt(),
        couponFiscalNumber: newCouponNumber,
        pdvId: homePresenter.commandEntity!.pdv!.PdvId!,
        pdvNumber: homePresenter.commandEntity!.pdv!.PdvNumber!,
        covenantCode: _selectedCustomer?.covenantCode,
        customerCode: _selectedCustomer?.customer.Code,
        cpfCnpj: _cpfCnpj?.toString(),
        incrementType: serviceChargeValue == 0 ? null : 1,
        incrementValue: serviceChargeValue == 0 ? null : serviceChargeValue,
        totalLiquid: printedProductsPresenter
            .getTotalLiquid(printedProductsPresenter.printed),
        finalizations: _successfulPayments.map((e) => e.toEntity()).toList(),
        products: printedProductsPresenter.printed!.Products,
        xmlToGenerateFiscal: useSharing == false ? xmlReponse?.response : null,
      );

      _couponNumber = newCouponNumber;
      await couponFiscalNumber.save(newCouponNumber);
      _successfulPayments.clear();
      showSuccessAndCloseUntilHomePage();
      _lastRequestedPaymentFinalization = null;
      _authorizationPendingModel = null;
      await deleteSaleRequest
          .delete(printedProductsPresenter.printed!.SaleRequestId!.toInt());
      await printedProductsPresenter.loadPrinted(
        homePresenter.commandEntity!.commandNumber!,
      );
    } catch (e) {
      mainError = getUIError(e);
    } finally {
      isLoading = false;
    }
  }

  MethodChannel redeChannel = MethodChannel(Channels.rede.name);

  @override
  void initRedePaymentResultHandler({
    required HomePresenter homePresenter,
    required PrintedProductsPresenter printedProductsPresenter,
    required void Function() showSuccessAndCloseUntilHomePage,
    required void Function(String error) showErrorMessageReturnedByBs,
  }) {
    if (!homePresenter.isGeneratingVersionToRede) {
      return;
    }

    redeChannel.setMethodCallHandler((MethodCall call) async {
      await _treatRedeResponse(
        homePresenter,
        printedProductsPresenter,
        call,
        showSuccessAndCloseUntilHomePage,
        showErrorMessageReturnedByBs,
      );
    });
  }

  Future<void> _treatGetNetResponse(
    HomePresenter homePresenter,
    GetNetResponseModel? response,
    PrintedProductsPresenter printedProductsPresenter,
    void Function() showSuccessAndCloseUntilHomePage,
    void Function(String error) showErrorMessageReturnedByBs,
  ) async {
    try {
      if (response?.result == "0") {
        await liquidateCommand(
          homePresenter: homePresenter,
          printedProductsPresenter: printedProductsPresenter,
          showSuccessAndCloseUntilHomePage: showSuccessAndCloseUntilHomePage,
          showErrorMessageReturnedByBs: showErrorMessageReturnedByBs,
        );
      } else if (response?.result == "1") {
        mainError = UIError.paymentDeclined;
      } else if (response?.result == "2") {
        mainError = UIError.paymentCanceled;
      } else if (response?.result == "3") {
        mainError = UIError.paymentFailed;
      } else if (response?.result == "4") {
        mainError = UIError.paymentUnexpectedError;
      } else if (response?.result == "5") {
        mainError = UIError.paymentPendant;
      } else {
        mainError = UIError.paymentUnexpectedError;
      }
    } catch (e) {
      mainError = getUIError(e);
    }
    isLoading = false;
  }

  Future<void> _treatRedeResponse(
    HomePresenter homePresenter,
    PrintedProductsPresenter printedProductsPresenter,
    MethodCall call,
    void Function() showSuccessAndCloseUntilHomePage,
    void Function(String error) showErrorMessageReturnedByBs,
  ) async {
    if (call.arguments == "Pagamento Autorizado") {
      try {
        await liquidateCommand(
          homePresenter: homePresenter,
          printedProductsPresenter: printedProductsPresenter,
          showSuccessAndCloseUntilHomePage: showSuccessAndCloseUntilHomePage,
          showErrorMessageReturnedByBs: showErrorMessageReturnedByBs,
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
    isLoading = false;
  }

  @override
  void disposePaymentResultHandler() {
    redeChannel.setMethodCallHandler(null);
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
    _selectedCustomer = null;

    try {
      validateCustomerField(value);

      _authorizationPendingModel = null;

      SoapResponse? soapResponse;

      soapResponse = await loadCustomer.load(
        value: value,
        searchByPersonalizedCode: searchByPersonalizedCode,
      );

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
      mainError = getUIError(e);
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
  Future<void> updateSelectedCustomer(
    CustomerViewModel? customer,
    int? covenantCode,
  ) async {
    _authorizationPendingModel = null;

    if (customer == null) {
      _selectedCustomer = null;
    } else {
      _selectedCustomer = SelectedCustomerModel(
        customer: CustomerModel.fromViewModel(customer),
        covenantCode: covenantCode?.toInt(),
      );
    }
  }

  @override
  Future<void> finishSaleRequestByCovenant({
    required HomePresenter homePresenter,
    required PrintedProductsPresenter printedProductsPresenter,
    required void Function(String error) showErrorMessageReturnedByBs,
    required void Function() showSuccessAndCloseUntilHomePage,
    required String? customerPassword,
  }) async {
    mainError = null;
    isLoading = true;
    try {
      if (customerPassword != null && customerPassword.isNotEmpty) {
        final passwordResponse = await checkPasswordByCustomerCode.validate(
          customerCode: _selectedCustomer!.customer.Code!,
          password: customerPassword,
        );
        if (passwordResponse.responseType == SoapResponseType.error) {
          showErrorMessageReturnedByBs(passwordResponse.response);
          return;
        }
      }

      double pendingValue = getTotalPendingValue(printedProductsPresenter);

      SoapResponse? authorizationSoapResponse;
      if (_authorizationPendingModel == null) {
        authorizationSoapResponse = await covenantLimit
            .authorizeCovenantLimitUseByCodeAndGetAuthorizeCode(
          crossIdentity: EnterpriseBuilder.entity!
              .enterpriseConcentradorParametersEntity?.celtaBSCrossIdentity,
          customerCode: _selectedCustomer!.customer.Code!,
          covenantCode: _selectedCustomer!.covenantCode!,
          value: pendingValue,
        );

        _authorizationPendingModel = AuthorizationPendingModel(
          code: authorizationSoapResponse.response,
          isPending: true,
        );

        _successfulPayments.add(
          ConcentratorFinalizationModel(
            FinalizationId: FinalizationType.covenant.id,
            Value: pendingValue,
            ValueLiquid: pendingValue,
            PortionQuantity: 1,
            AuthorizationCode: authorizationSoapResponse.response,
            AuthorizationType: 2,
          ),
        );
      }

      if (authorizationSoapResponse?.responseType == SoapResponseType.error) {
        showErrorMessageReturnedByBs(authorizationSoapResponse!.response);
      } else {
        await liquidateCommand(
          homePresenter: homePresenter,
          printedProductsPresenter: printedProductsPresenter,
          showSuccessAndCloseUntilHomePage: showSuccessAndCloseUntilHomePage,
          showErrorMessageReturnedByBs: showErrorMessageReturnedByBs,
        );
      }
    } catch (e) {
      mainError = getUIError(e);
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

  SelectedCustomerModel? _selectedCustomer;
  @override
  SelectedCustomerModel? get selectedCustomer => _selectedCustomer;

  AuthorizationPendingModel? _authorizationPendingModel;

  @override
  AuthorizationPendingModel? get authorizationPendingModel =>
      _authorizationPendingModel;

  int? _couponNumber;
  @override
  int? get couponNumber => _couponNumber;

  int? _cpfCnpj;
  @override
  int? get cpfCnpj => _cpfCnpj;

  @override
  void changeCpfCnpj(String? value) {
    if (int.tryParse(value ?? "") == null) {
      _cpfCnpj = null;
    } else if (validateCpfCnpj.isValid(value)) {
      _cpfCnpj = value!.toInt();
    } else {
      _cpfCnpj = null;
    }
  }
}
