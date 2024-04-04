import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
import '../../infra/helpers/helperts.dart';
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
        FocusNodeManager
    implements LoginPresenter {
  final Validation validation;
  final Authentication authentication;
  final SaveCrossId saveCrossId;
  final SaveUrl saveUrl;
  final SaveUser saveUser;

  GetxLoginPresenter({
    required this.validation,
    required this.authentication,
    required this.saveCrossId,
    required this.saveUrl,
    required this.saveUser,
  });

  final _userError = Rx<UIError?>(null);
  final _passwordError = Rx<UIError?>(null);
  final _urlError = Rx<UIError?>(null);

  String? _user;
  String? _password;
  String? _url;

  @override
  Stream<UIError?> get userErrorStream => _userError.stream;
  @override
  Stream<UIError?> get passwordErrorStream => _passwordError.stream;
  @override
  Stream<UIError?> get urlErrorStream => _urlError.stream;

  @override
  void validateUser(String user) {
    _user = user;
    _userError.value = _validateField('user');
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
    _url = url;
    _urlError.value = _validateField(CacheKeys.url.name);
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
      'user': _user,
      'password': _password,
      CacheKeys.url.name: _url,
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
        _user?.isNotEmpty == true &&
        _password?.isNotEmpty == true &&
        _url?.isNotEmpty == true;
  }

  @override
  Future<void> auth() async {
    try {
      mainError = null;
      isLoading = true;
      await saveUrl.save(_url!);
      await saveUser.save(_user!);

      final account = await authentication.auth(
        AuthenticationParams(
          user: _user!,
          password: _password!,
          url: _url!,
        ),
      );

      await saveCrossId.save(account);
      navigateTo = '/home';
    } on DomainError {
      mainError = UIError.unexpected;

      isLoading = false;
    }
  }
}
