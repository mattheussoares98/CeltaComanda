// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/ui/pages/pages.dart';
import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'dart:async';
import 'package:mocktail/mocktail.dart';

class LoginPresenterSpy extends Mock implements LoginPresenter {
  final userErrorController = StreamController<UIError?>();
  final passwordErrorController = StreamController<UIError?>();
  final urlCcsErrorController = StreamController<UIError?>();
  final mainErrorController = StreamController<UIError?>();
  final navigateToController = StreamController<String?>();
  final isFormValidController = StreamController<bool>();
  final isLoadingController = StreamController<bool>();
  final passwordFocus = FocusNode();
  final urlCcsFocus = FocusNode();

  LoginPresenterSpy() {
    when(() => this.passwordFocusNode).thenReturn(passwordFocus);
    when(() => this.urlCcsFocusNode).thenReturn(urlCcsFocus);
    when(() => this.onSubmitUser("any value")).thenAnswer(
      (_) async => FocusScope.of(Get.context!).requestFocus(this.passwordFocus),
    );
    when(() => this.onSubmitPassword("any value")).thenAnswer(
      (_) async => FocusScope.of(Get.context!).requestFocus(this.urlCcsFocus),
    );
    when(() => this.auth()).thenAnswer((_) async => _);
    when(() => this.userErrorStream)
        .thenAnswer((_) => userErrorController.stream);
    when(() => this.passwordErrorStream)
        .thenAnswer((_) => passwordErrorController.stream);
    when(() => this.urlCcsErrorStream)
        .thenAnswer((_) => urlCcsErrorController.stream);
    when(() => this.mainErrorStream)
        .thenAnswer((_) => mainErrorController.stream);
    when(() => this.navigateToStream)
        .thenAnswer((_) => navigateToController.stream);
    when(() => this.isFormValidStream)
        .thenAnswer((_) => isFormValidController.stream);
    when(() => this.isLoadingStream)
        .thenAnswer((_) => isLoadingController.stream);
  }

  void emitUserError(UIError error) => userErrorController.add(error);
  void emitUserValid() => userErrorController.add(null);
  void emitPasswordError(UIError error) => passwordErrorController.add(error);
  void emitPasswordValid() => passwordErrorController.add(null);
  void emitUrlCcsError(UIError error) => urlCcsErrorController.add(error);
  void emitUrlCcsValid() => urlCcsErrorController.add(null);
  void emitFormError() => isFormValidController.add(false);
  void emitFormValid() => isFormValidController.add(true);
  void emitLoading([bool show = true]) => isLoadingController.add(show);
  void emitMainError(UIError error) => mainErrorController.add(error);
  void emitNavigateTo(String route) => navigateToController.add(route);

  void dispose() {
    userErrorController.close();
    passwordErrorController.close();
    urlCcsErrorController.close();
    mainErrorController.close();
    navigateToController.close();
    isFormValidController.close();
    isLoadingController.close();
  }
}
