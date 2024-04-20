import 'package:clean_celta_mobile/domain/entities/entities.dart';

import '../../../data/usecases/login_data/login_data.dart';
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
  final LocalLoginData localLoginData;
  final RemoteLoginData remoteLoginData;
  final NavigateTo navigateTo;
  final LoadApiSaleRequest loadApiSaleRequest;

  GetxEnterpriseValidationPresenter({
    required this.validation,
    required this.localLoginData,
    required this.remoteLoginData,
    required this.navigateTo,
    required this.loadApiSaleRequest,
  });

  @override
  bool isUpdatedEnterpriseName = false;

  final _enterpriseError = Rx<UIError?>(null);
  @override
  Stream<UIError?> get enterpriseErrorStream => _enterpriseError.stream;

  @override
  Future<void> loadLocalData() async {
    LoginDataBuilder.loginDataEntity = await localLoginData.load();

    if (LoginDataBuilder.loginDataEntity?.enterpriseName?.isNotEmpty == true) {
      updateEnterpriseController(
          LoginDataBuilder.loginDataEntity!.enterpriseName!);
    }
  }

  @override
  Future<void> loadRemoteData() async {
    LoginDataBuilder.loginDataEntity = await remoteLoginData.load(
        loginEntity: LoginDataBuilder.loginDataEntity);

    if (LoginDataBuilder.loginDataEntity?.enterpriseName?.isNotEmpty == true) {
      enterpriseNameController.text =
          LoginDataBuilder.loginDataEntity!.enterpriseName!;
      await localLoginData.add(LoginDataBuilder.loginDataEntity!);
    }

    isUpdatedEnterpriseName = false;
  }

  @override
  Future<void> validateApiSaleRequest() async {
    try {
      mainError = null;
      isLoading = true;

      await localLoginData.add(LoginDataBuilder.loginDataEntity!);

      if (isUpdatedEnterpriseName) {
        await loadRemoteData();
        await localLoginData.add(LoginDataBuilder.loginDataEntity!);
      }

      if (LoginDataBuilder.loginDataEntity == null) {
        throw DomainError.enterpriseOrUrlNotFound;
      }

      await loadApiSaleRequest.load(
        url: LoginDataBuilder.loginDataEntity!.url,
        enterpriseId: LoginDataBuilder.loginDataEntity!.enterpriseId!,
      );

      navigateTo.navigate(pageRoute: PageRoutes.expansibleGroups);
    } on DomainError catch (error) {
      switch (error) {
        case DomainError.enterpriseOrUrlNotFound:
          mainError = UIError.enterpriseOrUrlNotFound;
          isLoading = false;
          break;
        default:
          mainError = UIError.unexpected;
          isLoading = false;
      }
    }
  }

  @override
  void validateEnterpriseInput(String value,
      {bool? updateEnterpriseNameController = false}) {
    enterpriseNameController.text = value;
    _enterpriseError.value = _validateField('enterpriseName');
    _validateForm();
    if (updateEnterpriseNameController == true) {
      isUpdatedEnterpriseName = true;
    }

    LoginDataBuilder.loginDataEntity = LoginDataEntity(
      url: "url",
      userName: "userName",
      enterpriseName: enterpriseNameController.text,
    );
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
}
