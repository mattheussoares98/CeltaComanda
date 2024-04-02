// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:clean_celta_mobile/ui/pages/pages.dart';

import 'dart:async';
import 'package:mocktail/mocktail.dart';

class ExpansibleGroupsPresenterSpy extends Mock
    implements ExpansibleGroupsPresenter {
  final navigateToController = StreamController<String?>();
  final mainErrorController = StreamController<UIError?>();
  final isLoadingController = StreamController<bool>();

  ExpansibleGroupsPresenterSpy() {
    when(() => this.getProducts()).thenAnswer((_) async => _);
    when(() => this.navigateToStream)
        .thenAnswer((_) => navigateToController.stream);
    when(() => this.mainErrorStream)
        .thenAnswer((_) => mainErrorController.stream);
    when(() => this.isLoadingStream)
        .thenAnswer((_) => isLoadingController.stream);
  }
  void emitNavigateTo(String route) => navigateToController.add(route);
  void emitLoading([bool show = true]) => isLoadingController.add(show);
  void emitMainError(UIError error) => mainErrorController.add(error);

  void dispose() {
    navigateToController.close();
    mainErrorController.close();
    isLoadingController.close();
  }
}
