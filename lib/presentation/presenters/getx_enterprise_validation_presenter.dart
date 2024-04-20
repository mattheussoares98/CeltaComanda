import '../../../data/usecases/login_data/login_data.dart';
import '../../domain/entities/entities.dart';
import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
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

  GetxEnterpriseValidationPresenter({
    required this.validation,
    required this.localLoginData,
    required this.remoteLoginData,
    required this.navigateTo,
  });

  @override
  bool isUpdatedEnterpriseName = false;

  final _enterpriseError = Rx<UIError?>(null);
  @override
  Stream<UIError?> get enterpriseErrorStream => _enterpriseError.stream;

  @override
  Future<void> loadLocalData() async {
    _loginData = await localLoginData.load();

    if (_loginData?.enterpriseName?.isNotEmpty == true) {
      updateEnterpriseController(_loginData!.enterpriseName!);
    }
  }

  LoginDataEntity? _loginData;
  @override
  LoginDataEntity? get loginData => _loginData;

  LoginDataEntity? _remoteEntity;
  @override
  LoginDataEntity? get remoteEntity => _remoteEntity;

  @override
  Future<void> loadRemoteData() async {
    _remoteEntity ??= await remoteLoginData.load(loginEntity: _loginData);

    if (_remoteEntity?.enterpriseName?.isNotEmpty == true) {
      enterpriseNameController.text = _remoteEntity!.enterpriseName!;
      await localLoginData.add(_remoteEntity!);
    }

    isUpdatedEnterpriseName = false;
  }

  @override
  Future<void> validateApiSaleRequest() async {
    try {
      mainError = null;
      isLoading = true;

      await localLoginData.add(_loginData!);

      if (isUpdatedEnterpriseName) {
        await loadRemoteData();
      }

      // await authentication.auth(
      //   AuthenticationParams(
      //     user: _loginData!.userName,
      //     password: _password!,
      //     url: _loginData!.url,
      //   ),
      // );

      await addLoginDataInDatabase(_loginData!);

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
  Future<void> addLoginDataInDatabase(LoginDataEntity loginEntity) async {
    await loadRemoteData();

    if (_remoteEntity == null) {
      await remoteLoginData.add(_loginData!);
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
