import 'package:clean_celta_mobile/presentation/presenters/presenters.dart';

import '../../domain/mocks/mocks.dart';

import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late GetxSplashPresenter sut;
  late LoadCrossIdSpy loadCrossId;

  setUp(() {
    loadCrossId = LoadCrossIdSpy();
    loadCrossId.mockLoad(account: EntityFactory.makeAccount());
    sut = GetxSplashPresenter(loadCrossId: loadCrossId);
  });

  setUpAll(() {
    registerFallbackValue(EntityFactory.makeAccount());
  });

  test('Should call LoadCrossId', () async {
    await sut.checkAccount(durationInSeconds: 0);

    verify(() => loadCrossId.load()).called(1);
  });

  test('Should go to surveys page on success', () async {
    sut.navigateToStream
        .listen(expectAsync1((page) => expect(page, '/home')));

    await sut.checkAccount(durationInSeconds: 0);
  });

  test('Should go to login page on error', () async {
    loadCrossId.mockLoadError();

    sut.navigateToStream.listen(expectAsync1((page) => expect(page, '/login')));

    await sut.checkAccount(durationInSeconds: 0);
  });
}
