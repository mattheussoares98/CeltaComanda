// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/ui/pages/pages.dart';
import 'package:clean_celta_mobile/ui/helpers/helpers.dart';

import 'dart:async';
import 'package:mocktail/mocktail.dart';

class ExpansibleGroupFromProductPresenterSpy extends Mock
    implements ExpansibleGroupFromProductPresenter {
  final mainErrorController = StreamController<UIError?>();
  final isLoadingController = StreamController<bool>();
  List<ExpansibleGroupFromProductViewModel> loadedCommentsController = [];
  List<ExpansibleGroupFromProductViewModel> loadedObligatoryOptionsController =
      [];
  final bool hasSelectedCommentsController = false;

  ExpansibleGroupFromProductPresenterSpy() {
    when(() => this.mainErrorStream)
        .thenAnswer((_) => mainErrorController.stream);
    when(() => this.isLoadingStream)
        .thenAnswer((_) => isLoadingController.stream);
    when(() => this.loadedComments).thenAnswer((_) => loadedCommentsController);
    when(() => this.loadedObligatoryOptions)
        .thenAnswer((_) => loadedObligatoryOptionsController);
    when(() => this.changeCommentIsSelected(any())).thenAnswer((_) async => _);
    when(() => this.productHasComment(
          product: any(named: "product"),
          indexOfChild: any(named: "indexOfChild"),
        )).thenAnswer((_) => false);
    when(() => this.loadCommentsAndObligatoryOptions(any()))
        .thenAnswer((_) async => _);
  }

  void mockGetConcatenateSelectedComments(String? comment) {
    when(() => this.getConcatenateSelectedCommentsAndObligatoryOptions(any()))
        .thenAnswer((_) => comment);
  }

  void mockProductHasComment(bool value) {
    when(() => this.productHasComment(
          product: any(named: "product"),
          indexOfChild: any(named: "indexOfChild"),
        )).thenAnswer((_) => value);
  }

  void mockProductHasObligatoryOptions(bool value) {
    when(() => this.productHasObligatoryOption(
          product: any(named: "product"),
          indexOfChild: any(named: "indexOfChild"),
        )).thenAnswer((_) => value);
  }
}
