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

  bool _isUpdatedUrlController = false;

  @override
  bool get isUpdatedUrlController => _isUpdatedUrlController;

  LoginDataEntity? _loginData;

  @override
  LoginDataEntity? get loginData => _loginData;

  @override
  void validateUser(String user) {
    userNameController.text = user;
    _userError.value = _validateField('userName');
    _validateForm();
  }

  @override
  void validatePassword(String password) {
    _password = password;
    _passwordError.value = _validateField('password');
    _validateForm();
  }

  @override
  void validateUrl(String url) {
    urlController.text = url;
    _urlError.value = _validateField('url');
    if (_isUpdatedUrlController == false) {
      _isUpdatedUrlController = true;
    }
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

  @override
  Future<void> auth() async {
    try {
      mainError = null;
      isLoading = true;

      await localLoginData.save(
        LoginDataEntity(
          url: urlController.text.contains("http") ? urlController.text : "",
          userName: userNameController.text,
          enterpriseName:
              !urlController.text.contains("http") ? urlController.text : "",
        ),
      );

      if (_isUpdatedUrlController) {
        await loadRemoteData();
      }

      final account = await authentication.auth(
        AuthenticationParams(
          user: userNameController.text,
          password: _password!,
          url: _loginData!.url,
        ),
      );

      await saveCrossId.save(account);

      navigateTo = '/home';
    } on DomainError catch (error) {
      switch (error) {
        case DomainError.enterpriseOrUrlNotFound:
          mainError = UIError.enterpriseOrUrlNotFound;
          throw DomainError.enterpriseOrUrlNotFound;
        default:
          mainError = UIError.unexpected;
          throw DomainError.unexpected;
      }
    } finally {
      isLoading = false;
    }
  }

  @override
  void updateUserAndUrlTexts() {
    if (_loginData != null) {
      userNameController.text = _loginData!.userName;
      urlController.text = _loginData!.enterpriseName?.isNotEmpty == true
          ? _loginData!.enterpriseName!
          : _loginData!.url;
    }
  }

  @override
  Future<void> loadLocalData() async {
    isLoading = true;

    _loginData = await localLoginData.load();
    updateUserAndUrlTexts();

    isLoading = false;
  }

  @override
  Future<void> loadRemoteData() async {
    isLoading = true;

    _loginData = await remoteLoginData.load(loginData: _loginData);
    // _loginData = remoteData;
    updateUserAndUrlTexts();
    _isUpdatedUrlController = false;
    isLoading = false;
  }
}
