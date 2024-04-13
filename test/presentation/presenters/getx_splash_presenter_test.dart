import 'package:clean_celta_mobile/presentation/presenters/presenters.dart';
import 'package:clean_celta_mobile/ui/helpers/helpers.dart';

import '../../domain/mocks/mocks.dart';

import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late GetxSplashPresenter sut;
  late CrossIdSpy crossIdSpy;

  setUp(() {
    crossIdSpy = CrossIdSpy();
    crossIdSpy.mockLoad(account: EntityFactory.makeAccount());
    sut = GetxSplashPresenter(loadCrossId: crossIdSpy);
  });

  setUpAll(() {
    registerFallbackValue(EntityFactory.makeAccount());
  });

  test('Should call LoadCrossId', () async {
    await sut.checkAccount(durationInSeconds: 0);

    verify(() => crossIdSpy.load()).called(1);
  });

  test('Should go to surveys page on success', () async {
    sut.navigateToStream.listen(
        expectAsync1((page) => expect(page, PageRoutes.expansibleGroups)));

    await sut.checkAccount(durationInSeconds: 0);
  });

  test('Should go to login page on error', () async {
    crossIdSpy.mockLoadError();

    sut.navigateToStream
        .listen(expectAsync1((page) => expect(page, PageRoutes.login)));

    await sut.checkAccount(durationInSeconds: 0);
  });
}
