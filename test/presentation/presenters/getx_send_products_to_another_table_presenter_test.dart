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

      await sut.sendProductsToAnotherTable(
        oldPersonalizedCode: oldPersonalizedCode,
        newPersonalizedCode: newPersonalizedCode,
        cartPresenter: cartPresenter,
        homePresenter: homePresenter,
      );
    });

    test("Should emit correct values on DomainError.selectProducts", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.selectProducts]));

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
      int firstSelected = faker.randomGenerator.integer(100);
      int secondSelected = faker.randomGenerator.integer(100);

      sut.updateProductIsSelected(firstSelected);
      sut.updateProductIsSelected(secondSelected);

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
          saleRequestProductsIds: [firstSelected, secondSelected],
        ),
      ).called(1);
    });
    test("Should reload products after send products to another table",
        () async {
      int firstSelected = faker.randomGenerator.integer(100);
      sut.updateProductIsSelected(firstSelected);

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
        "Should call cartPresenter.insertServiceChargeProduct with in old command number when has service charge product",
        () async {
      final entityWithServiceChargeProduct = EntityFactory.makePrintedEntity(
        productPriceLookUpCode: EnterpriseBuilder.entity!.pluServiceCharge,
      );
      loadPrintedProducts.mockLoadPrintedEntity(entityWithServiceChargeProduct);
      await sut.loadProducts(commandNumber);

      int firstSelected = faker.randomGenerator.integer(100);
      sut.updateProductIsSelected(firstSelected);

      await sut.sendProductsToAnotherTable(
        oldPersonalizedCode: oldPersonalizedCode,
        newPersonalizedCode: newPersonalizedCode,
        cartPresenter: cartPresenter,
        homePresenter: homePresenter,
      );

      verify(
        () => cartPresenter.insertServiceChargeProduct(
          oldPersonalizedCode.toString(),
        ),
      ).called(1);
    });
    test(
        "Should not call cartPresenter.insertServiceChargeProduct with in old command number when dont has service charge product",
        () async {
      int firstSelected = faker.randomGenerator.integer(100);
      sut.updateProductIsSelected(firstSelected);

      await sut.sendProductsToAnotherTable(
        oldPersonalizedCode: oldPersonalizedCode,
        newPersonalizedCode: newPersonalizedCode,
        cartPresenter: cartPresenter,
        homePresenter: homePresenter,
      );

      verifyNever(
        () => cartPresenter.insertServiceChargeProduct(
          oldPersonalizedCode.toString(),
        ),
      );
    });
    test(
        "Should call cartPresenter.insertServiceChargeProduct with in new command number",
        () async {
      int firstSelected = faker.randomGenerator.integer(100);
      sut.updateProductIsSelected(firstSelected);

      await sut.sendProductsToAnotherTable(
        oldPersonalizedCode: oldPersonalizedCode,
        newPersonalizedCode: newPersonalizedCode,
        cartPresenter: cartPresenter,
        homePresenter: homePresenter,
      );

      verify(
        () => cartPresenter.insertServiceChargeProduct(
          newPersonalizedCode.toString(),
        ),
      ).called(1);
    });
    test("Should emit correct error if try to send service charge product",
        () async {
      final saleRequestProductId = faker.randomGenerator.integer(100);
      final serviceChargeProduct = PrintedProductsEntity(
        ProductInternalCodeOnErp:
            EnterpriseBuilder.entity!.internalCodeOnErpServiceCharge!,
        SaleRequestProductId: saleRequestProductId,
        Product: EntityFactory.makeProductsEntitys()[0],
        ProductPriceLookUpCode: faker.randomGenerator.string(10),
        Value: faker.randomGenerator.decimal(),
        Quantity: faker.randomGenerator.decimal(),
        QuantityString: faker.randomGenerator.string(10),
        Comments: faker.randomGenerator.string(10),
        UserId: faker.randomGenerator.integer(100),
        DateHourOfCreation: faker.randomGenerator.string(10),
        IsCancelled: faker.randomGenerator.boolean(),
        IsDelivered: faker.randomGenerator.boolean(),
        IsPrinted: faker.randomGenerator.boolean(),
        ProductionStatus: faker.randomGenerator.integer(100),
        TotalLiquid: faker.randomGenerator.decimal(),
        SaleRequestId: faker.randomGenerator.integer(100),
        ProductIsFatherComposition: faker.randomGenerator.boolean(),
        childs: [],
        SaleRequestProductIdOfFather: faker.randomGenerator.integer(100),
      );
      final printedEntity = PrintedEntity(
        Products: [serviceChargeProduct],
        PersonalizedCode: faker.randomGenerator.string(10),
        DateOfCreation: faker.randomGenerator.string(10),
        DateHourOfCreation: faker.randomGenerator.string(10),
        FlagStatus: faker.randomGenerator.string(10),
        EnterpriseId: faker.randomGenerator.integer(100),
        RequestType: faker.randomGenerator.string(10),
        IsCancelled: faker.randomGenerator.boolean(),
        IsUsing: faker.randomGenerator.boolean(),
        TotalLiquid: faker.randomGenerator.decimal(),
        Peoples: faker.randomGenerator.integer(100),
        SaleRequestId: faker.randomGenerator.integer(100),
        FlagOrigin: faker.randomGenerator.integer(100),
        DeliveryControl: faker.randomGenerator.integer(100),
        IncrementType: faker.randomGenerator.integer(100),
        IncrementValue: faker.randomGenerator.decimal(),
      );

      loadPrintedProducts.mockLoadPrintedEntity(printedEntity);

      expectLater(
        sut.mainErrorStream,
        emitsInOrder([null, UIError.cantSendServiceChargeProduct]),
      );

      await sut.loadProducts(commandNumber);
      sut.updateProductIsSelected(saleRequestProductId);

      await sut.sendProductsToAnotherTable(
        oldPersonalizedCode: oldPersonalizedCode,
        newPersonalizedCode: newPersonalizedCode,
        cartPresenter: cartPresenter,
        homePresenter: homePresenter,
      );
    });

    test("Should load printed products from new command", () async {
      sut.updateProductIsSelected(faker.randomGenerator.integer(100));

      await sut.sendProductsToAnotherTable(
        oldPersonalizedCode: oldPersonalizedCode,
        newPersonalizedCode: newPersonalizedCode,
        cartPresenter: cartPresenter,
        homePresenter: homePresenter,
      );

      verify(() => loadPrintedProducts.load(commandNumber: newPersonalizedCode))
          .called(1);
    });
    test(
        "Should not add service charge product in destiny command if doesnt already exists",
        () async {
      sut.updateProductIsSelected(faker.randomGenerator.integer(100));

      await sut.sendProductsToAnotherTable(
        oldPersonalizedCode: oldPersonalizedCode,
        newPersonalizedCode: newPersonalizedCode,
        cartPresenter: cartPresenter,
        homePresenter: homePresenter,
      );

      verifyNever(() => cartPresenter.insertServiceChargeProduct(
            newPersonalizedCode.toString(),
          ));
    });
    test(
        "Should add service charge product in destiny command if already exists service charge product",
        () async {
      loadPrintedProducts.mockLoadPrintedEntity(
        EntityFactory.makePrintedEntity(
          productPriceLookUpCode: EnterpriseBuilder.entity!.pluServiceCharge,
        ),
      );

      sut.updateProductIsSelected(faker.randomGenerator.integer(100));

      await sut.sendProductsToAnotherTable(
        oldPersonalizedCode: oldPersonalizedCode,
        newPersonalizedCode: newPersonalizedCode,
        cartPresenter: cartPresenter,
        homePresenter: homePresenter,
      );

      verify(() => cartPresenter.insertServiceChargeProduct(
            newPersonalizedCode.toString(),
          )).called(1);
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
          printedViewModel.Products.map((e) => e.SaleRequestProductId.toInt())
              .toList());
    });
  });
}
