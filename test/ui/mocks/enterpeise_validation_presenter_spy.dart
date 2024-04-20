// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:clean_celta_mobile/ui/pages/pages.dart';
import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:flutter/material.dart';

import 'dart:async';
import 'package:mocktail/mocktail.dart';

class LoginDataEntitySpy extends Mock implements LoginDataEntity {}

class EnterpriseValidationPresenterSpy extends Mock
    implements EnterpriseValidationPresenter {
  final mainErrorController = StreamController<UIError?>();
  final enterpriseErrorController = StreamController<UIError?>();
  final isFormValidController = StreamController<bool>();
  final isLoadingController = StreamController<bool>();
  final enterpriseNameTextEditingController = TextEditingController();
  final bool isUpdatedEnterpriseNameController = false;

  EnterpriseValidationPresenterSpy() {
    when(() => this.isUpdatedEnterpriseName)
        .thenReturn(isUpdatedEnterpriseNameController);
    when(() => this.enterpriseNameController)
        .thenReturn(enterpriseNameTextEditingController);

    when(() => this.loadLocalData()).thenAnswer((_) async => _);

    when(() => this.mainErrorStream)
        .thenAnswer((_) => mainErrorController.stream);

    when(() => this.enterpriseErrorStream)
        .thenAnswer((_) => enterpriseErrorController.stream);
    when(() => this.isFormValidStream)
        .thenAnswer((_) => isFormValidController.stream);
    when(() => this.isLoadingStream)
        .thenAnswer((_) => isLoadingController.stream);

    when(() => this.loginData).thenReturn(LoginDataEntitySpy());
    when(() => this.remoteEntity).thenReturn(null);
  }

  void emitFormError() => isFormValidController.add(false);
  void emitFormValid() => isFormValidController.add(true);
  void emitLoading([bool show = true]) => isLoadingController.add(show);
  void emitMainError(UIError error) => mainErrorController.add(error);
  void mockLoadRemoteData(LoginDataEntity? loginEntity) {
    when(() => this.loadRemoteData()).thenAnswer((_) async => loginEntity);
  }

  void dispose() {
    mainErrorController.close();
    isFormValidController.close();
    isLoadingController.close();
  }
}
