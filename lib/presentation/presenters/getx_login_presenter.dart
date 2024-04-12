import '../../../data/usecases/login_data/login_data.dart';
import '../../domain/entities/entities.dart';
import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';
import '../protocols/protocols.dart';
import '../mixins/mixins.dart';

import 'package:get/get.dart';

class GetxLoginPresenter extends GetxController
    with
        LoadingManager,
        NavigationManager,
        FormManager,
        UIErrorManager,
        FocusNodeManager,
        TextControllerManager
    implements LoginPresenter {
  final Validation validation;
  final Authentication authentication;
  final SaveCrossId saveCrossId;
  final LocalLoginData localLoginData;
  final RemoteLoginData remoteLoginData;

  GetxLoginPresenter({
    required this.validation,
    required this.authentication,
    required this.saveCrossId,
    required this.localLoginData,
    required this.remoteLoginData,
  });

  final _userError = Rx<UIError?>(null);
  final _passwordError = Rx<UIError?>(null);
  final _urlError = Rx<UIError?>(null);

  String? _password;

  @override
  Stream<UIError?> get userErrorStream => _userError.stream;
  @override
  Stream<UIError?> get passwordErrorStream => _passwordError.stream;
  @override
  Stream<UIError?> get urlErrorStream => _urlError.stream;

  LoginDataEntity? _loginData;
  @override
  LoginDataEntity? get loginData => _loginData;

  LoginDataEntity? _remoteEntity;
  @override
  LoginDataEntity? get remoteEntity => _remoteEntity;

  @override
  bool isUpdatedUrlController = false;

  @override
  void validateUser(String user) {
    userNameController.text = user;
    _userError.value = _validateField('userName');
    _updateLoginData();
    _validateForm();
  }

  @override
  void validatePassword(String password) {
    _password = password;
    _passwordError.value = _validateField('password');
    _updateLoginData();
    _validateForm();
  }

  @override
  void validateUrl(String url, {bool? updateUrlController = false}) {
    urlController.text = url;
    _urlError.value = _validateField('url');
    if (updateUrlController == true) {
      isUpdatedUrlController = true;
    }
    _updateLoginData();
    _validateForm();
  }

  @override
  void onSubmitUser(String value) {
    changeFocus(passwordFocusNode);
  }

  @override
  void onSubmitPassword(String value) {
    changeFocus(urlFocusNode);
  }

  UIError? _validateField(String field) {
    final formData = {
      'userName': userNameController.text,
      'password': _password,
      'url': urlController.text,
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
    isFormValid = _userError.value == null &&
        _passwordError.value == null &&
        _urlError.value == null &&
        userNameController.text.isNotEmpty == true &&
        _password?.isNotEmpty == true &&
        urlController.text.isNotEmpty == true;
  }

  void _updateLoginData() {
    _loginData = LoginDataEntity(
      url: urlController.text.contains("http") ? urlController.text : "",
      userName: userNameController.text,
      enterpriseName:
          !urlController.text.contains("http") ? urlController.text : "",
    );
  }

  @override
  Future<void> auth() async {
    try {
      mainError = null;
      isLoading = true;

      await localLoginData.add(_loginData!);

      if (isUpdatedUrlController) {
        await loadRemoteData();
      }

      final account = await authentication.auth(
        AuthenticationParams(
          user: _loginData!.userName,
          password: _password!,
          url: _loginData!.url,
        ),
      );

      await saveCrossId.save(account);

      await addLoginDataInDatabase(_loginData!);

      navigateTo = '/home';
    } on DomainError catch (error) {
      switch (error) {
        case DomainError.enterpriseOrUrlNotFound:
          mainError = UIError.enterpriseOrUrlNotFound;
          isLoading = false;
          break;
        // throw DomainError.enterpriseOrUrlNotFound;
        default:
          mainError = UIError.unexpected;
          isLoading = false;
        // throw DomainError.unexpected;
      }
    }
  }

  @override
  void updateUserAndUrlTexts(LoginDataEntity? loginEntity) {
    if (loginEntity != null) {
      userNameController.text = loginEntity.userName;
      urlController.text = loginEntity.enterpriseName?.isNotEmpty == true
          ? loginEntity.enterpriseName!
          : loginEntity.url;
    }
  }

  @override
  Future<void> loadLocalData() async {
    _loginData = await localLoginData.load();
    updateUserAndUrlTexts(_loginData);
  }

  @override
  Future<LoginDataEntity?> loadRemoteData() async {
    LoginDataEntity? value;
    if (_remoteEntity == null) {
      value = await remoteLoginData.load(loginEntity: _loginData);
      updateUserAndUrlTexts(value);
      isUpdatedUrlController = false;
    }
    _remoteEntity = value;
    return value;
  }

  @override
  Future<void> addLoginDataInDatabase(LoginDataEntity loginEntity) async {
    await loadRemoteData();

    if (_remoteEntity == null) {
      await remoteLoginData.add(_loginData!);
    }
  }
}
