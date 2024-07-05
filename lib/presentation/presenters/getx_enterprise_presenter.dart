import '../../data/usecases/enterprise/enterprise.dart';
import '../../domain/entities/entities.dart';
import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
import '../../main/builders/builders.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';
import '../protocols/protocols.dart';
import '../mixins/mixins.dart';

import 'package:get/get.dart';

class GetxEnterpriseValidationPresenter extends GetxController
    with TextControllerManager, LoadingManager, FormManager, UIErrorManager
    implements EnterpriseValidationPresenter {
  final Validation validation;
  final LocalEnterpriseData localEntepriseData;
  final LoadEnterpriseData loadEnterpriseData;
  final NavigateTo navigateTo;
  final LoadSaleRequestTemp loadSaleRequestTemp;

  GetxEnterpriseValidationPresenter({
    required this.validation,
    required this.localEntepriseData,
    required this.loadEnterpriseData,
    required this.navigateTo,
    required this.loadSaleRequestTemp,
  });

  @override
  bool isUpdatedEnterpriseName = false;

  final _enterpriseError = Rx<UIError?>(null);
  @override
  Stream<UIError?> get enterpriseErrorStream => _enterpriseError.stream;

  final _useFixedCommandNumber = Rx<bool>(false);
  @override
  Stream<bool> get useFixedCommandNumber => _useFixedCommandNumber.stream;

  @override
  Future<void> loadLocalData() async {
    EnterpriseDataBuilder.enterpriseDataEntity =
        await localEntepriseData.load();

    if (EnterpriseDataBuilder.enterpriseDataEntity?.enterpriseName.isNotEmpty ==
        true) {
      updateEnterpriseController(
          EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseName);
    }
  }

  @override
  Future<void> loadRemoteData() async {
    try {
      final remoteData = await loadEnterpriseData.load();

      if (remoteData != null) {
        EnterpriseDataBuilder.enterpriseDataEntity = remoteData;
      } else {
        throw DomainError.enterpriseOrUrlNotFound;
      }

      if (EnterpriseDataBuilder
              .enterpriseDataEntity?.enterpriseName.isNotEmpty ==
          true) {
        enterpriseNameController.text =
            EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseName;
        await localEntepriseData
            .add(EnterpriseDataBuilder.enterpriseDataEntity!);
      }

      if (EnterpriseDataBuilder.enterpriseDataEntity == null) {
        throw DomainError.enterpriseOrUrlNotFound;
      }
    } catch (e) {
      throw DomainError.enterpriseOrUrlNotFound;
    } finally {
      isUpdatedEnterpriseName = false;
    }
  }

  @override
  Future<void> validateApiSaleRequest() async {
    try {
      mainError = null;
      isLoading = true;

      await localEntepriseData.add(EnterpriseDataBuilder.enterpriseDataEntity!);

      if (isUpdatedEnterpriseName ||
          EnterpriseDataBuilder.enterpriseDataEntity!.url == null) {
        await loadRemoteData();
      }

      await loadSaleRequestTemp.load(
        url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
        enterpriseId: EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId!,
        commandNumber:
            "001", //aqui é só pra testar se a API está disponível, por isso um valor fixo
      );

      isLoading = false;
      goToHomePage();
    } on DomainError catch (error) {
      switch (error) {
        case DomainError.enterpriseOrUrlNotFound:
          mainError = UIError.enterpriseOrUrlNotFound;
          break;
        case DomainError.commandNotAvailable:
          mainError = UIError.commandNotAvailable;
          break;
        default:
          mainError = UIError.unexpected;
      }
    } finally {
      isLoading = false;
    }
  }

  @override
  void validateEnterpriseInput(String value,
      {bool? updateEnterpriseNameController = false}) {
    enterpriseNameController.text = value;

    EnterpriseDataBuilder.enterpriseDataEntity = EnterpriseEntity(
      enterpriseName: enterpriseNameController.text,
    );

    _enterpriseError.value = _validateField('enterpriseName');
    _validateForm();
    if (updateEnterpriseNameController == true) {
      isUpdatedEnterpriseName = true;
    }
  }

  UIError? _validateField(String field) {
    final formData = {
      'enterpriseName': enterpriseNameController.text,
    };
    final error = validation.validate(field: field, input: formData);
    switch (error) {
      case ValidationError.invalidField:
        return UIError.invalidField;
      case ValidationError.requiredField:
        return UIError.requiredField;
      default:
        return null;
    }
  }

  void _validateForm() {
    isFormValid = _enterpriseError.value == null &&
        enterpriseNameController.text.isNotEmpty == true;
  }

  @override
  void goToHomePage() {
    navigateTo.navigate(pageRoute: PageRoutes.home, clear: true);
  }

  @override
  void updateUseFixedCommandNumber() {}
}
