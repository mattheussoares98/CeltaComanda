import '../../helpers/helpers.dart';

import 'package:flutter/material.dart';

abstract class LoginPresenter implements Listenable {
  Stream<UIError?> get userErrorStream;
  Stream<UIError?> get passwordErrorStream;
  Stream<UIError?> get urlErrorStream;
  Stream<UIError?> get mainErrorStream;
  Stream<String?> get navigateToStream;
  Stream<bool> get isFormValidStream;
  Stream<bool> get isLoadingStream;

  FocusNode get passwordFocusNode;
  FocusNode get urlFocusNode;

  void validateUser(String user);
  void onSubmitUser(String value);
  void onSubmitPassword(String value);
  void validatePassword(String password);
  void validateUrl(String url);
  Future<void> auth();
}