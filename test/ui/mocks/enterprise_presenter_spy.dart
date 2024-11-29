// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/ui/pages/pages.dart';
import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:flutter/material.dart';

import 'dart:async';
import 'package:mocktail/mocktail.dart';

class EnterpriseDataEntitySpy extends Mock implements EnterpriseEntity {}

class EnterprisePresenterSpy extends Mock implements EnterprisePresenter {
  final mainErrorController = StreamController<UIError?>();
  final enterpriseErrorController = StreamController<UIError?>();
  final isFormValidController = StreamController<bool>();
  final isLoadingController = StreamController<bool>();
  final enterpriseNameTextEditingController = TextEditingController();
  final bool isUpdatedEnterpriseNameController = false;

  EnterprisePresenterSpy() {
    when(() => this.isUpdatedEnterpriseName)
        .thenReturn(isUpdatedEnterpriseNameController);

    when(() => this.getLocalData()).thenAnswer((any) async => any);
    when(() => this.clearEnterpriseData()).thenAnswer((any) async => any);
    when(() => this.getFirebaseAndConcentradorEnterpriseParameters())
        .thenAnswer((any) async => any);
    when(() => this.updateConcentratorEnterpriseParameters())
        .thenAnswer((any) async => any);
    when(() => this.validateApiAndGoToHomePage(
          isFixedCommandNumber: any(named: "isFixedCommandNumber"),
          commandNumber: any(named: "commandNumber"),
          homePresenter: any(named: "homePresenter"),
        )).thenAnswer((any) async => any);
    when(() => this.validateEnterpriseInput(any(),
            updateEnterpriseNameController:
                any(named: "updateEnterpriseNameController")))
        .thenAnswer((any) async => any);

    when(() => this.mainErrorStream)
        .thenAnswer((_) => mainErrorController.stream);

    when(() => this.enterpriseErrorStream)
        .thenAnswer((_) => enterpriseErrorController.stream);
    when(() => this.isFormValidStream)
        .thenAnswer((_) => isFormValidController.stream);
    when(() => this.isLoadingStream)
        .thenAnswer((_) => isLoadingController.stream);
  }

  void emitFormError() => isFormValidController.add(false);
  void emitFormValid() => isFormValidController.add(true);
  void emitLoading([bool show = true]) => isLoadingController.add(show);
  void emitMainError(UIError error) => mainErrorController.add(error);
  void mockLoadRemoteData(EnterpriseEntity? enterpriseEntity) {
    when(() => this.getFirebaseAndConcentradorEnterpriseParameters())
        .thenAnswer((_) async => enterpriseEntity);
  }

  void mockLoadRemoteDataError() {
    when(() => this.getFirebaseAndConcentradorEnterpriseParameters())
        .thenThrow((_) async => DomainError.enterpriseOrUrlNotFound);
  }

  void dispose() {
    mainErrorController.close();
    isFormValidController.close();
    isLoadingController.close();
  }
}
