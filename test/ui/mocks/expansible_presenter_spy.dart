// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/ui/helpers/errors/errors.dart';
import 'package:clean_celta_mobile/ui/pages/pages.dart';

import 'dart:async';
import 'package:mocktail/mocktail.dart';

class ExpansibleGroupsPresenterSpy extends Mock
    implements ExpansibleGroupsPresenter {
  final navigateToController = StreamController<String?>();
  final mainErrorController =
      StreamController<List<ExpansibleGroupsViewModel>>();
  final isLoadingController = StreamController<bool>();
  final expansibleGroupsController =
      StreamController<List<ExpansibleGroupsViewModel>>();

  ExpansibleGroupsPresenterSpy() {
    when(() => this.loadExpansibleGroups()).thenAnswer((_) async => _);
    when(() => this.navigateToStream)
        .thenAnswer((_) => navigateToController.stream);
    when(() => this.expansibleGroupsStream)
        .thenAnswer((_) => expansibleGroupsController.stream);
    when(() => this.isLoadingStream)
        .thenAnswer((_) => isLoadingController.stream);
  }
  void mockExpansibleGroupStreamError(DomainError error) {
    expansibleGroupsController.addError(
      UIError.unexpected.description,
      StackTrace.current,
    );
  }

  void emitNavigateTo(String route) => navigateToController.add(route);
  void emitLoading([bool show = true]) => isLoadingController.add(show);

  void dispose() {
    navigateToController.close();
    mainErrorController.close();
    isLoadingController.close();
  }
}
