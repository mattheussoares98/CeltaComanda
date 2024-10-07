import '../../data/models/models.dart';
import '../../domain/entities/entities.dart';
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
  final FinishSaleRequestConcentrador finishSaleRequestConcentrador;
  final CovenantLimit covenantLimit;
  final CovenantAuthorizationIsPendant covenantAuthorizationIsPendant;
  final UpdateSaleRequest updateSaleRequest;

  GetxCovenantPresenter({
    required this.loadCustomer,
    required this.validation,
    required this.finishSaleRequestConcentrador,
    required this.covenantLimit,
    required this.covenantAuthorizationIsPendant,
    required this.updateSaleRequest,
  });

  @override
  Future<void> getCustomer(String value) async {
    mainError = null;
    isLoading = true;
    customersViewModel = null;
    _selectedCovenant = {};

    try {
      await covenantAuthorizationIsPendant.update(null);

      int? valueInInt = int.tryParse(value);

      List<CustomerEntity>? result;

// 1=ExactCnpjCpfNumber
// 2=ExactCode
// 3=ApproximateName
// 4=PersonalizedCode
      if (value.isEmpty) {
        return;
      } else if (valueInInt == null) {
        result = await loadCustomer.load(
          value: value,
          searchTypeInt: 3,
        );
      } else {
        if (valueInInt.toString().length == 11 ||
            valueInInt.toString().length == 14) {
          result = await loadCustomer.load(
            value: value,
            searchTypeInt: 1,
          );
        }
        result ??= await loadCustomer.load(
          value: value,
          searchTypeInt: 2,
        );
        result ??= await loadCustomer.load(
          value: value,
          searchTypeInt: 4,
        );
      }

      if (result == null) {
        mainError = UIError.notFound;
      } else {
        customersViewModel =
            result.map((e) => CustomerViewModel.fromEntity(e)).toList();
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
    isLoading = true;
    mainError = null;
    try {
      await covenantAuthorizationIsPendant.update(null);

      if (customer == null) {
        _selectedCovenant = {};
      } else {
        _selectedCovenant = {
          customer.Code!: covenantCode,
        };
      }
    } catch (e) {
      mainError = UIError.unexpected;
    } finally {
      isLoading = false;
    }
  }

  @override
  Future<void> finishSaleRequestByCovenant({
    required HomePresenter homePresenter,
    required PrintedProductsPresenter printedProductsPresenter,
    required void Function() closePagesUntilHomePage,
    required void Function(String error) showErrorMessageReturnedByBs,
  }) async {
    mainError = null;
    isLoading = true;
    try {
      SoapResponse soapResponse = await covenantLimit
          .authorizeCovenantLimitUseByCodeAndGetAuthorizeCode(
        crossIdentity: EnterpriseDataBuilder.enterpriseDataEntity!
            .enterpriseConcentradorParametersEntity?.celtaBSCrossIdentity,
        customerCode: _selectedCovenant.keys.first.toInt(),
        covenantCode: _selectedCovenant.values.first!.toInt(),
        value: printedProductsPresenter.printedProducts!.TotalLiquid.toDouble(),
      );

      if (soapResponse.responseType == SoapResponseType.error) {
        showErrorMessageReturnedByBs(soapResponse.response);
      } else {
        await covenantAuthorizationIsPendant.update(
          AuthorizationPendingModel(
            code: soapResponse.response,
            isPending: true,
          ),
        );

        await finishSaleRequestConcentrador.finish(
          pdvNumber: 100,
          commandNumber: homePresenter.commandNumber!.toInt(),
          finalizations: [
            ConcentratorFinalizationModel(
              FinalizationId:
                  FinalizationIdentification.covenant.finalizationId,
              Value: printedProductsPresenter.printedProducts!.TotalLiquid
                  .toDouble(),
              ValueLiquid: printedProductsPresenter.printedProducts!.TotalLiquid
                  .toDouble(),
              PortionQuantity: 1,
              AuthorizationCode: soapResponse.response,
            ),
          ],
        );
        await covenantAuthorizationIsPendant.update(null);

        await printedProductsPresenter.loadPrinted(homePresenter);

        closePagesUntilHomePage();
      }
    } catch (e) {
      mainError = UIError.unexpected;
    } finally {
      isLoading = false;
    }
  }

  @override
  Future<AuthorizationPendingModel?> getAuthorizationPendantModel() async {
    mainError = null;
    isLoading = true;
    try {
      final value = await covenantAuthorizationIsPendant.get();
      return value;
    } catch (e) {
      mainError = UIError.unexpected;
      return null;
    } finally {
      isLoading = false;
    }
  }
}
