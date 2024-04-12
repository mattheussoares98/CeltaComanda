// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:clean_celta_mobile/ui/pages/pages.dart';
import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'dart:async';
import 'package:mocktail/mocktail.dart';

class LoginDataEntitySpy extends Mock implements LoginDataEntity {}

class LoginPresenterSpy extends Mock implements LoginPresenter {
  final userErrorController = StreamController<UIError?>();
  final passwordErrorController = StreamController<UIError?>();
  final urlErrorController = StreamController<UIError?>();
  final mainErrorController = StreamController<UIError?>();
  final navigateToController = StreamController<String?>();
  final isFormValidController = StreamController<bool>();
  final isLoadingController = StreamController<bool>();
  final passwordFocus = FocusNode();
  final urlFocus = FocusNode();
  final userTextEditingController = TextEditingController();
  final urlTextEditingController = TextEditingController();
  final bool updatedUrlController = false;

  LoginPresenterSpy() {
    when(() => this.passwordFocusNode).thenReturn(passwordFocus);
    when(() => this.isUpdatedUrlController).thenReturn(updatedUrlController);
    when(() => this.urlFocusNode).thenReturn(urlFocus);
    when(() => this.userNameController).thenReturn(userTextEditingController);
    when(() => this.urlController).thenReturn(urlTextEditingController);
    when(() => this.onSubmitUser("any value")).thenAnswer(
      (_) async => FocusScope.of(Get.context!).requestFocus(this.passwordFocus),
    );
    when(() => this.onSubmitPassword("any value")).thenAnswer(
      (_) async => FocusScope.of(Get.context!).requestFocus(this.urlFocus),
    );
    when(() => this.auth()).thenAnswer((_) async => _);
    when(() => this.updateUserAndUrlTexts(any())).thenAnswer((_) async => _);
    when(() => this.addLoginDataInDatabase(any())).thenAnswer((_) async => _);
    when(() => this.loadLocalData()).thenAnswer((_) async => _);
    when(() => this.validateUser(any())).thenAnswer((_) async => _);
    when(() => this.validatePassword(any())).thenAnswer((_) async => _);
    when(() => this.validateUrl(any(), updateUrlController: any(named: "updateUrlController"))).thenAnswer((_) async => _);

    when(() => this.userErrorStream)
        .thenAnswer((_) => userErrorController.stream);
    when(() => this.passwordErrorStream)
        .thenAnswer((_) => passwordErrorController.stream);
    when(() => this.urlErrorStream)
        .thenAnswer((_) => urlErrorController.stream);
    when(() => this.mainErrorStream)
        .thenAnswer((_) => mainErrorController.stream);
    when(() => this.navigateToStream)
        .thenAnswer((_) => navigateToController.stream);
    when(() => this.isFormValidStream)
        .thenAnswer((_) => isFormValidController.stream);
    when(() => this.isLoadingStream)
        .thenAnswer((_) => isLoadingController.stream);

    when(
      () => this.validateUrl(
        any(),
        updateUrlController: any(named: "updateUrlController"),
      ),
    ).thenAnswer((_) async => _);

    when(() => this.loginData).thenReturn(LoginDataEntitySpy());
    when(() => this.remoteEntity).thenReturn(null);
  }

  void emitUserError(UIError error) => userErrorController.add(error);
  void emitUserValid() => userErrorController.add(null);
  void emitPasswordError(UIError error) => passwordErrorController.add(error);
  void emitPasswordValid() => passwordErrorController.add(null);
  void emitUrlError(UIError error) => urlErrorController.add(error);
  void emitUrlValid() => urlErrorController.add(null);
  void emitFormError() => isFormValidController.add(false);
  void emitFormValid() => isFormValidController.add(true);
  void emitLoading([bool show = true]) => isLoadingController.add(show);
  void emitMainError(UIError error) => mainErrorController.add(error);
  void emitNavigateTo(String route) => navigateToController.add(route);
  void mockLoadRemoteData(LoginDataEntity? loginEntity) {
    when(() => this.loadRemoteData()).thenAnswer((_) async => loginEntity);
  }

  void dispose() {
    userErrorController.close();
    passwordErrorController.close();
    urlErrorController.close();
    mainErrorController.close();
    navigateToController.close();
    isFormValidController.close();
    isLoadingController.close();
  }
}
