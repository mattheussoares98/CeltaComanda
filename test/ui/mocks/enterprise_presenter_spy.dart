// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/ui/pages/pages.dart';
import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'dart:async';
import 'package:mocktail/mocktail.dart';

class EnterpriseDataEntitySpy extends Mock implements EnterpriseEntity {}

class EnterpriseValidationPresenterSpy extends Mock
    implements EnterpriseValidationPresenter {
  final mainErrorController = StreamController<UIError?>();
  final enterpriseErrorController = StreamController<UIError?>();
  final isFormValidController = StreamController<bool>();
  final isLoadingController = StreamController<bool>();
  final useFixedCommandNumberController = StreamController<CommandViewModel>();
  final enterpriseNameTextEditingController = TextEditingController();
  final bool isUpdatedEnterpriseNameController = false;

  EnterpriseValidationPresenterSpy() {
    when(() => this.isUpdatedEnterpriseName)
        .thenReturn(isUpdatedEnterpriseNameController);
    when(() => this.enterpriseNameController)
        .thenReturn(enterpriseNameTextEditingController);

    when(() => this.loadLocalData()).thenAnswer((any) async => any);
    when(() => this.loadRemoteEnterpriseData()).thenAnswer((any) async => any);
    when(() => this.getEnterpriseAndValidateApiIsAvailable(
          commandEntity: any(named: "commandEntity"),
          homePresenter: any(named: "homePresenter"),
        )).thenAnswer((any) async => any);
    when(() => this.goToHomePage()).thenAnswer((_) => Get.offNamed(
          PageRoutes.menus,
        ));
    when(() => this.updateEnterpriseController(any()))
        .thenAnswer((any) async => any);
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
    when(() => this.commandDataStream)
        .thenAnswer((_) => useFixedCommandNumberController.stream);
  }

  void emitFormError() => isFormValidController.add(false);
  void emitFormValid() => isFormValidController.add(true);
  void emitLoading([bool show = true]) => isLoadingController.add(show);
  void emitMainError(UIError error) => mainErrorController.add(error);
  void mockLoadRemoteData(EnterpriseEntity? enterpriseEntity) {
    when(() => this.loadRemoteEnterpriseData())
        .thenAnswer((_) async => enterpriseEntity);
  }

  void mockLoadRemoteDataError() {
    when(() => this.loadRemoteEnterpriseData())
        .thenThrow((_) async => DomainError.enterpriseOrUrlNotFound);
  }

  void dispose() {
    mainErrorController.close();
    isFormValidController.close();
    isLoadingController.close();
  }
}
