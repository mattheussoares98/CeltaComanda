import 'package:clean_celta_mobile/presentation/presenters/presenters.dart';
import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:faker/faker.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../data/mocks/mocks.dart';

void main() {
  late GetxCancelProductsPresenter sut;

  late RemovePrintedProductSpy removePrintedProduct;

  void initUsecases() {
    removePrintedProduct = RemovePrintedProductSpy();
  }

  void initPresenters() {
    sut = GetxCancelProductsPresenter(
      removePrintedProduct: removePrintedProduct,
    );
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
    test("Should emit correct values on error", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));

      removePrintedProduct.mockError();

      await sut.cancelProduct(faker.randomGenerator.string(10));
    });
    test("Should call removePrintedProduct with correct value", () async {
      final id = faker.randomGenerator.string(10);

      await sut.cancelProduct(id);

      verify(() => removePrintedProduct.remove(id)).called(1);
    });
  });
}
