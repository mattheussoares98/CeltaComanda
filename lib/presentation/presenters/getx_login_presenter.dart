import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';
import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
import '../protocols/protocols.dart';
import '../mixins/mixins.dart';

import 'package:get/get.dart';

class GetxLoginPresenter extends GetxController
    with LoadingManager, NavigationManager, FormManager, UIErrorManager
    implements LoginPresenter {
  final Validation validation;
  final Authentication authentication;
  final SaveCrossId saveCrossId;

  final _userError = Rx<UIError?>(null);
  final _passwordError = Rx<UIError?>(null);
  final _urlCcsError = Rx<UIError?>(null);

  String? _user;
  String? _password;
  String? _urlCcs;

  @override
  Stream<UIError?> get userErrorStream => _userError.stream;
  @override
  Stream<UIError?> get passwordErrorStream => _passwordError.stream;
  @override
  Stream<UIError?> get urlCcsErrorStream => _urlCcsError.stream;

  GetxLoginPresenter({
    required this.validation,
    required this.authentication,
    required this.saveCrossId,
  });

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
  void validateUrlCcs(String urlCcs) {
    _urlCcs = urlCcs;
    _passwordError.value = _validateField('urlCcs');
    _validateForm();
  }

  UIError? _validateField(String field) {
    final formData = {
      R.string.user: _user,
      'password': _password,
      'ccsUrl': _urlCcs,
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
        _user != null &&
        _password != null;
  }

  @override
  Future<void> auth() async {
    try {
      mainError = null;
      isLoading = true;
      final account = await authentication.auth(
        AuthenticationParams(
          user: _user!,
          password: _password!,
          urlCcs: _urlCcs!,
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
