import '../../helpers/helpers.dart';
import '../../../domain/entities/entities.dart';

import 'package:flutter/material.dart';

abstract class LoginPresenter implements Listenable {
  Stream<UIError?> get userErrorStream;
  Stream<UIError?> get passwordErrorStream;
  Stream<UIError?> get urlErrorStream;
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isFormValidStream;
  Stream<bool> get isLoadingStream;

  bool isUpdatedUrlController = false;

  FocusNode get passwordFocusNode;
  FocusNode get urlFocusNode;
  TextEditingController get userNameController;
  TextEditingController get urlController;

  LoginDataEntity? get loginData;
  LoginDataEntity? get remoteEntity;

  void validateUser(String user);
  void onSubmitUser(String value);
  void onSubmitPassword(String value);
  void validatePassword(String password);
  void validateUrl(String url, {bool? updateUrlController = false});
  Future<void> auth();
  Future<void> loadRemoteData();
  Future<void> loadLocalData();
  void updateUserAndUrlTexts(LoginDataEntity? loginEntity);
  Future<void> addLoginDataInDatabase(LoginDataEntity loginEntity);
}
