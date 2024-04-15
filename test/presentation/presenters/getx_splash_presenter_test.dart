import 'package:clean_celta_mobile/presentation/presenters/presenters.dart';
import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../domain/mocks/mocks.dart';

import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late GetxSplashPresenter sut;
  late CrossIdSpy crossIdSpy;
  late NavigateToSpy navigateTo;
  WidgetsFlutterBinding.ensureInitialized();
  Get.testMode = true;

  setUp(() {
    crossIdSpy = CrossIdSpy();
    // crossIdSpy.mockLoad(account: EntityFactory.makeAccount());
    navigateTo = NavigateToSpy();
    navigateTo.mockNavigate();
    crossIdSpy.mockLoad(account: EntityFactory.makeAccount());
    sut = GetxSplashPresenter(
      loadCrossId: crossIdSpy,
      navigateTo: navigateTo,
    );
  });

  setUpAll(() {
    registerFallbackValue(EntityFactory.makeAccount());
  });

  test('Should call LoadCrossId', () async {
    await sut.checkAccount(durationInSeconds: 0);

    verify(() => crossIdSpy.load()).called(1);
  });

  test('Should go to surveys page on success', () async {
    await sut.checkAccount(durationInSeconds: 0);

    verify(
      () => navigateTo.navigate(pageRoute: PageRoutes.expansibleGroups),
    ).called(1);
  });

  test('Should go to login page on error', () async {
    crossIdSpy.mockLoadError();
    await sut.checkAccount(durationInSeconds: 0);

    verify(
      () => navigateTo.navigate(pageRoute: PageRoutes.login),
    ).called(1);
  });
}
