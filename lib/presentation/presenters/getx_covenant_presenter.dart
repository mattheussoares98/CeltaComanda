import 'dart:convert';

import '../../data/models/models.dart';
import '../../domain/usecases/usecases.dart';
import '../../infra/helpers/helperts.dart';
import '../../main/builders/builders.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';
import '../mixins/mixins.dart';

import 'package:get/get.dart';

import '../protocols/protocols.dart';

class GetxCovenantPresenter extends GetxController
    with LoadingManager, UIErrorManager
    implements CovenantPresenter {
  final Validation validation;
  final LoadCustomer loadCustomer;
  final CovenantLimit covenantLimit;
  final UpdateSaleRequest updateSaleRequest;
  final CheckPasswordByCustomerCode checkPasswordByCustomerCode;

  GetxCovenantPresenter({
    required this.loadCustomer,
    required this.validation,
    required this.covenantLimit,
    required this.updateSaleRequest,
    required this.checkPasswordByCustomerCode,
  });

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

  final _customerError = Rx<ValidationError?>(null);
  @override
  Stream<ValidationError?> get customerErrorStream => _customerError.stream;
  set customerError(ValidationError? value) => _customerError.value = value;

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

  final _customersViewModelStream = Rx<List<CustomerViewModel>?>(null);
  @override
  Stream<List<CustomerViewModel>?> get customersViewModelStream =>
      _customersViewModelStream.stream;
  set customersViewModel(List<CustomerViewModel>? customer) =>
      _customersViewModelStream.subject.add(customer);

  Map<String, String?> _selectedCovenant = {};
  @override
  Map<String, String?> get selectedCovenant => _selectedCovenant;

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
    required PaymentPresenter paymentPresenter,
    required void Function() closePagesUntilHomePage,
    required void Function(String error) showErrorMessageReturnedByBs,
    required String? customerPassword,
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

      SoapResponse soapResponse = await covenantLimit
          .authorizeCovenantLimitUseByCodeAndGetAuthorizeCode(
        crossIdentity: EnterpriseDataBuilder.enterpriseDataEntity!
            .enterpriseConcentradorParametersEntity?.celtaBSCrossIdentity,
        customerCode: _selectedCovenant.keys.first.toInt(),
        covenantCode: _selectedCovenant.values.first!.toInt(),
        value: printedProductsPresenter.printed!.TotalLiquid.toDouble(),
      );

      if (soapResponse.responseType == SoapResponseType.error) {
        showErrorMessageReturnedByBs(soapResponse.response);
      } else {
        _authorizationPendingModel = AuthorizationPendingModel(
          code: soapResponse.response,
          isPending: true,
        );

        await updateSaleRequest.update(
          model: SaleRequestModel(
            CustomerCode: _selectedCovenant.keys.first.toInt(),
            CovenantCode: _selectedCovenant.values.first!.toInt(),
          ),
          commandNumberWithThreeNumbers:
              homePresenter.commandNumber!.toString().padLeft(3, "0"),
          saleRequestId:
              printedProductsPresenter.printed!.SaleRequestId.toInt(),
        );

        //add new finalization in paymentPresent.succesfulFinalizations and call finish

        _authorizationPendingModel = null;

        await printedProductsPresenter.loadPrinted(homePresenter.commandNumber!);

        closePagesUntilHomePage();
      }
    } catch (e) {
      mainError = UIError.unexpected;
    } finally {
      isLoading = false;
    }
  }

  AuthorizationPendingModel? _authorizationPendingModel;

  @override
  AuthorizationPendingModel? get authorizationPendingModel =>
      _authorizationPendingModel;
}
