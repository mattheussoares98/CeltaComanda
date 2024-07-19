// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/ui/pages/pages.dart';
import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:flutter/material.dart';

import 'dart:async';
import 'package:mocktail/mocktail.dart';

class ProductCompositionPresenterSpy extends Mock
    implements ProductCompositionPresenter {
  final mainErrorController = StreamController<UIError?>();
  final enterpriseErrorController = StreamController<UIError?>();
  final productsCompositionController =
      StreamController<List<ProductCompositionViewModel>>();
  final isLoadingController = StreamController<bool>();
  final enterpriseNameTextEditingController = TextEditingController();
  final bool isUpdatedEnterpriseNameController = false;

  ProductCompositionPresenterSpy() {
    when(() => this.mainErrorStream)
        .thenAnswer((_) => mainErrorController.stream);
    when(() => this.isLoadingStream)
        .thenAnswer((_) => isLoadingController.stream);
    when(() => this.productsCompositionStream)
        .thenAnswer((_) => productsCompositionController.stream);
  }

  void emitLoading([bool show = true]) => isLoadingController.add(show);
  void emitMainError(UIError error) => mainErrorController.add(error);

  void dispose() {
    mainErrorController.close();
    isLoadingController.close();
  }
}
