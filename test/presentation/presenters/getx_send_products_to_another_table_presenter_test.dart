import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/main/builders/builders.dart';
import 'package:clean_celta_mobile/presentation/presenters/presenters.dart';
import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:clean_celta_mobile/ui/pages/pages.dart';
import 'package:faker/faker.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../data/mocks/mocks.dart';
import '../../domain/mocks/mocks.dart';
import '../../ui/mocks/mocks.dart';

void main() {
  late GetxSendProductsToAnotherTablePresenter sut;
  late CartPresenterSpy cartPresenter;
  late HomePresenterSpy homePresenter;

  late LoadPrintedProductsSpy loadPrintedProducts;
  late ChangeSaleRequestPersonalizedCodeProductsSpy
      changeSaleRequestPersonalizedCodeProducts;

  late int commandNumber;
  late PrintedEntity printedEntity;
  late PrintedViewModel printedViewModel;

  void initUsecases() {
    loadPrintedProducts = LoadPrintedProductsSpy();
    changeSaleRequestPersonalizedCodeProducts =
        ChangeSaleRequestPersonalizedCodeProductsSpy();
  }

  void initPresenters() {
    homePresenter = HomePresenterSpy();
    cartPresenter = CartPresenterSpy();

    sut = GetxSendProductsToAnotherTablePresenter(
      loadPrintedProducts: loadPrintedProducts,
      changeSaleRequestPersonalizedCodeProducts:
          changeSaleRequestPersonalizedCodeProducts,
    );
  }

  void initEntitys() {
    EnterpriseBuilder.entity = EntityFactory.makeEnterpriseData();
    commandNumber = faker.randomGenerator.integer(100);
    printedEntity = EntityFactory.makePrintedEntity();
    printedViewModel = PrintedViewModel.fromEntity(printedEntity);
  }

  void initMockSuccess() {
    loadPrintedProducts.mockLoadPrintedEntity(printedEntity);
  }

  setUp(() {
    initUsecases();
    initPresenters();
    initEntitys();
    initMockSuccess();
  });

  setUpAll(() {
    registerFallbackValue(
      EntityFactory.makeCartProductEntity(
        maximumProductQuantity: 0,
        minimumProductQuantity: 0,
      ),
    );
    registerFallbackValue(
      EntityFactory.makeExpansibleGroupFromProductViewModel(),
    );
    registerFallbackValue(EntityFactory.makeProductsViewModel());
    registerFallbackValue(HomePresenterSpy());
    registerFallbackValue(ExpansibleGroupFromProductPresenterSpy());
    registerFallbackValue(PrintedProductsPresenterSpy());
    registerFallbackValue(MenuPresenterSpy());
    registerFallbackValue(CartPresenterSpy());
  });

  group("Load printed products", () {
    test("Should emit correct values on success", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.mainErrorStream, emits(null));
      expectLater(sut.printedProducts, emitsInOrder([null, printedViewModel]));

      await sut.loadProducts(commandNumber);
    });
    test("Should emit correct values on commandNotAvailable", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.mainErrorStream,
          emitsInOrder([null, UIError.commandNotAvailable]));

      loadPrintedProducts.mockError(DomainError.commandNotAvailable);

      await sut.loadProducts(commandNumber);
    });
    test("Should emit correct values on unexpected error", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));

      loadPrintedProducts.mockError(DomainError.unexpected);

      await sut.loadProducts(commandNumber);
    });
    test("Should clear all selecteds products sale request ids", () async {
      sut.updateProductIsSelected(0);
      expect(sut.selectedsSaleRequestProductsIds, [0]);

      await sut.loadProducts(commandNumber);
      expect(sut.selectedsSaleRequestProductsIds, []);
    });
  });

  group("Send products to another table", () {
    final int oldPersonalizedCode = faker.randomGenerator.integer(100);
    final int newPersonalizedCode = faker.randomGenerator.integer(100);

    test("Should emit correct values on success", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.mainErrorStream, emits(null));

      await sut.loadProducts(commandNumber);
      await sut.sendProductsToAnotherTable(
        oldPersonalizedCode: oldPersonalizedCode,
        newPersonalizedCode: newPersonalizedCode,
        cartPresenter: cartPresenter,
        homePresenter: homePresenter,
      );
    });

    test("Should emit correct values on DomainError.unexpected", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));

      sut.updateProductIsSelected(faker.randomGenerator.integer(0));

      changeSaleRequestPersonalizedCodeProducts
          .mockError(DomainError.unexpected);

      await sut.loadProducts(commandNumber);
      await sut.sendProductsToAnotherTable(
        oldPersonalizedCode: oldPersonalizedCode,
        newPersonalizedCode: newPersonalizedCode,
        cartPresenter: cartPresenter,
        homePresenter: homePresenter,
      );
    });

    test(
        "Should call changeSaleRequestPersonalizedCodeProducts with correct values",
        () async {
      await sut.loadProducts(commandNumber);
      await sut.sendProductsToAnotherTable(
        oldPersonalizedCode: oldPersonalizedCode,
        newPersonalizedCode: newPersonalizedCode,
        cartPresenter: cartPresenter,
        homePresenter: homePresenter,
      );

      verify(
        () => changeSaleRequestPersonalizedCodeProducts.change(
          oldPersonalizedCode: oldPersonalizedCode.toString().padLeft(3, "0"),
          newPersonalizedCode: newPersonalizedCode.toString().padLeft(3, "0"),
          saleRequestProductsIds:
              printedEntity.Products.where((e) => e.IsCancelled == false)
                  .map((e) => e.SaleRequestProductId!.toInt())
                  .toList(),
        ),
      ).called(1);
    });
    test("Should reload products after send products to another table",
        () async {
      int firstSelected = faker.randomGenerator.integer(100);
      sut.updateProductIsSelected(firstSelected);

      await sut.loadProducts(commandNumber);
      await sut.sendProductsToAnotherTable(
        oldPersonalizedCode: oldPersonalizedCode,
        newPersonalizedCode: newPersonalizedCode,
        cartPresenter: cartPresenter,
        homePresenter: homePresenter,
      );

      verify(
        () => loadPrintedProducts.load(
          commandNumber: oldPersonalizedCode,
        ),
      ).called(1);
    });

    test(
        "Should not call cartPresenter.insertServiceChargeProduct with in old command number when dont has service charge product",
        () async {
      int firstSelected = faker.randomGenerator.integer(100);
      sut.updateProductIsSelected(firstSelected);

      await sut.loadProducts(commandNumber);
      await sut.sendProductsToAnotherTable(
        oldPersonalizedCode: oldPersonalizedCode,
        newPersonalizedCode: newPersonalizedCode,
        cartPresenter: cartPresenter,
        homePresenter: homePresenter,
      );

      verifyNever(
        () => cartPresenter.updateIncrementValue(
          oldPersonalizedCode.toString(),
        ),
      );
    });

    test("Should update increment value in old and new personalized codes",
        () async {
      await sut.loadProducts(commandNumber);
      await sut.sendProductsToAnotherTable(
        oldPersonalizedCode: oldPersonalizedCode,
        newPersonalizedCode: newPersonalizedCode,
        cartPresenter: cartPresenter,
        homePresenter: homePresenter,
      );

      verify(() => cartPresenter.updateIncrementValue(
          oldPersonalizedCode.toString().padLeft(3, "0"))).called(1);
      verify(() => cartPresenter.updateIncrementValue(
          newPersonalizedCode.toString().padLeft(3, "0"))).called(1);
    });
  });

  group("Update product is selected", () {
    test("Should update product is selected correctly", () {
      sut.updateProductIsSelected(0);
      sut.updateProductIsSelected(1);
      sut.updateProductIsSelected(2);
      expect(sut.selectedsSaleRequestProductsIds, [0, 1, 2]);

      sut.updateProductIsSelected(2);
      expect(sut.selectedsSaleRequestProductsIds, [0, 1]);
    });
  });

  group("Clear all selecteds sale request products ids", () {
    test("Should clear selectedsSaleRequestProductsIds", () {
      sut.updateProductIsSelected(0);
      sut.updateProductIsSelected(1);
      expect(sut.selectedsSaleRequestProductsIds, [0, 1]);

      sut.clearAllSelectedsSaleRequestProductsIds();
      expect(sut.selectedsSaleRequestProductsIds, []);
    });
  });

  group("Select all products", () {
    test("Should select all products correctly", () async {
      await sut.loadProducts(commandNumber);
      expect(sut.selectedsSaleRequestProductsIds, isEmpty);

      sut.selectAllProducts();
      expect(
          sut.selectedsSaleRequestProductsIds,
          printedViewModel.Products.where((e) => e.IsCancelled == "false")
              .map((e) => e.SaleRequestProductId!.toInt())
              .toList());
    });
  });
}
