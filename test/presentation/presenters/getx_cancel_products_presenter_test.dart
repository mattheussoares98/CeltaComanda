import 'package:clean_celta_mobile/presentation/presenters/presenters.dart';
import 'package:faker/faker.dart';

import 'package:flutter_test/flutter_test.dart';

void main() {
  late GetxCancelProductsPresenter sut;

  void initUsecases() {}
  void initPresenters() {
    sut = GetxCancelProductsPresenter();
  }

  void initEntitys() {}
  void initMockSuccess() {}

  setUp(() {
    initUsecases();
    initPresenters();
    initEntitys();
    initMockSuccess();
  });
  setUpAll(() {});

  group("Cancel product", () {
    test("Should emit correct values on success", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.mainErrorStream, emits(null));

      await sut.cancelProduct(faker.randomGenerator.string(10));
    });
  });
}
