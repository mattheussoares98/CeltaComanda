import '../../domain/entities/entities.dart';
import '../../domain/usecases/usecases.dart';
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
  final LoadSaleRequestTemp loadSaleRequestTemp;
  GetxCovenantPresenter({
    required this.loadCustomer,
    required this.validation,
    required this.loadSaleRequestTemp,
  });

  @override
  Future<void> getCustomer(String value) async {
    mainError = null;
    isLoading = true;
    customersViewModel = null;
    try {
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
  void updateSelectedCovenant(CustomerViewModel customer, String? newValue) {
    _selectedCovenant = {
      customer.Code: newValue,
    };
  }

  @override
  Future<void> updateCustomerAndCovenantAndFinishSaleRequestTemp(
    HomePresenter homePresenter,
  ) async {
    mainError = null;
    isLoading = true;
    try {} catch (e) {
      mainError = UIError.unexpected;
    } finally {
      isLoading = false;
    }
  }
}
