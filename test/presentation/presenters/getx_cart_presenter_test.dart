import 'package:clean_celta_mobile/data/models/models.dart';
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
  late GetxCartPresenter sut;
  late MenuPresenterSpy menuPresenter;
  late PrintedProductsPresenterSpy printedProductsPresenter;
  late HomePresenterSpy homePresenter;
  late ExpansibleGroupFromProductPresenterSpy
      expansibleGroupFromProductPresenter;
  late InsertProductsPresenterSpy insertProductPresenter;

  late LoadSaleRequestTempSpy loadSaleRequestTemp;
  late FinishSaleRequestTempByIdSpy finishSaleRequestTempById;
  late AddPrintRequestSpy addPrintRequest;
  late LocalPrintRequestSpy localPrintRequest;
  late UpdateSaleRequestTempSpy updateSaleRequestTemp;
  late ConfirmedCartProductsSpy confirmedCartProducts;
  late CartInformationsSpy cartInformations;
  late BarcodeScannerSpy barcodeScanner;
  late CommandInformationsSpy commandInformations;
  late LoadSaleRequestSpy loadSaleRequest;
  late UpdateSaleRequestSpy updateSaleRequest;
  late RemovePrintedProductSpy removePrintedProduct;

  late SaleRequestTempEntity saleRequestTempEntity;
  late String comments;
  late CartProductEntity cartProductEntityWithChilds;
  late UpdateSaleRequestTempEntity updateSaleRequestTempEntity;
  late List<UpdateSaleRequestTempProductEntity>
      cartSaleRequestTempProductsEntity;
  late CartProductsViewModel cartProductViewModelWithChilds;
  late CartProductEntity cartProductWithOneQuantity;
  late List<ProductCompositionViewModel> productsSelectedsInCombox;
  late int tableNumber;
  late ExpansibleGroupFromProductViewModel commentViewModel;
  late PrintRequestEntity printRequestEntity;
  late SaleRequestEntity saleRequestEntity;
  late SaleRequestModel saleRequestModel;

  void initUsecases() {
    loadSaleRequestTemp = LoadSaleRequestTempSpy();
    // finishSaleRequestTemp = FinishSaleRequestTempSpy();
    addPrintRequest = AddPrintRequestSpy();
    localPrintRequest = LocalPrintRequestSpy();
    updateSaleRequestTemp = UpdateSaleRequestTempSpy();
    confirmedCartProducts = ConfirmedCartProductsSpy();
    cartInformations = CartInformationsSpy();
    barcodeScanner = BarcodeScannerSpy();
    commandInformations = CommandInformationsSpy();
    finishSaleRequestTempById = FinishSaleRequestTempByIdSpy();
    updateSaleRequest = UpdateSaleRequestSpy();
    removePrintedProduct = RemovePrintedProductSpy();
  }

  void initPresenters() {
    menuPresenter = MenuPresenterSpy();
    printedProductsPresenter = PrintedProductsPresenterSpy();
    homePresenter = HomePresenterSpy();
    insertProductPresenter = InsertProductsPresenterSpy();
    loadSaleRequest = LoadSaleRequestSpy();

    sut = GetxCartPresenter(
      loadSaleRequestTemp: loadSaleRequestTemp,
      finishSaleRequestTempById: finishSaleRequestTempById,
      addPrintRequest: addPrintRequest,
      localPrintRequest: localPrintRequest,
      updateSaleRequestTemp: updateSaleRequestTemp,
      confirmedCartProducts: confirmedCartProducts,
      cartInformations: cartInformations,
      barcodeScanner: barcodeScanner,
      commandInformations: commandInformations,
      loadSaleRequest: loadSaleRequest,
      updateSaleRequest: updateSaleRequest,
      removePrintedProduct: removePrintedProduct,
    );
    expansibleGroupFromProductPresenter =
        ExpansibleGroupFromProductPresenterSpy();
  }

  void initEntitys() {
    EnterpriseBuilder.entity = EntityFactory.makeEnterpriseData();
    homePresenter.commandEntityController = EntityFactory.makeCommandEntity();
    comments = faker.randomGenerator.string(10);
    tableNumber = faker.randomGenerator.integer(1000, min: 1);

    saleRequestTempEntity =
        EntityFactory.makeSaleRequestTempEntity(tableNumber);
    cartProductEntityWithChilds = EntityFactory.makeCartProductEntity(
      generateChilds: true,
      maximumProductQuantity: 200,
      minimumProductQuantity: 2,
    );
    cartProductWithOneQuantity = EntityFactory.makeCartProductEntity(
      generateChilds: true,
      maximumProductQuantity: 1,
      minimumProductQuantity: 1,
    );

    cartSaleRequestTempProductsEntity = sut.cartProducts
        .map((element) => UpdateSaleRequestTempProductEntity(
              ProductInternalCodeOnErp:
                  element.toEntity().Product.InternalCodeOnERP!.toInt(),
              ProductPriceLookUpCode: element.toEntity().ProductPriceLookUpCode,
              Quantity: element.Quantity.toDouble(),
              SaleRequestTempId:
                  saleRequestTempEntity.SaleRequestTempId.toInt(),
              TotalLiquid: element.TotalLiquid.toDouble(),
              Value: element.Value.toDouble(),
              Comments: element.Comments,
              SaleRequestProductIdOfFather: null,
              ProductIsFatherComposition: null,
            ))
        .toList();

    productsSelectedsInCombox = [
      EntityFactory.makeProductCompositionViewModel(
        quantity: 1,
        salePrice: 20,
        offerPrice: 10,
        fatherIncrement: 5,
        isOptionalItem: false,
        indexOfSelectedChild: 0,
        insertChilds: false,
        childIncrement: 0,
      ),
      EntityFactory.makeProductCompositionViewModel(
        quantity: 2,
        salePrice: 20,
        offerPrice: 10,
        fatherIncrement: 5,
        isOptionalItem: false,
        indexOfSelectedChild: 0,
        insertChilds: false,
        childIncrement: 0,
      ),
      EntityFactory.makeProductCompositionViewModel(
        quantity: 2,
        salePrice: 20,
        offerPrice: 10,
        fatherIncrement: 5,
        isOptionalItem: false,
        indexOfSelectedChild:
            null, //não selecionado, por isso não considera nos produtos pra serem inseridos na comanda
        insertChilds: false,
        childIncrement: 0,
      ),
    ];

    updateSaleRequestTempEntity = UpdateSaleRequestTempEntity(
      DeliveryControl: saleRequestTempEntity.DeliveryControl,
      EnterpriseId: saleRequestTempEntity.EnterpriseId,
      PersonalizedCode: saleRequestTempEntity.PersonalizedCode,
      SaleRequestTempId: saleRequestTempEntity.SaleRequestTempId,
      TotalLiquid: cartSaleRequestTempProductsEntity.fold(
          0.0, (previousValue, element) => element.TotalLiquid + previousValue),
      Products: cartSaleRequestTempProductsEntity,
      Comments: saleRequestTempEntity.Comments,
      Peoples: saleRequestTempEntity.Peoples,
      SellerCode: saleRequestTempEntity.SellerCode,
      CustomerCode: saleRequestTempEntity.CustomerCode,
      CovenantCode: saleRequestTempEntity.CovenantCode,
      IncrementValue: EnterpriseBuilder.entity?.serviceChargePercentageOrValue,
      IncrementType: EnterpriseBuilder.entity?.serviceChargeType,
    );

    cartProductViewModelWithChilds =
        CartProductsViewModel.fromEntity(cartProductEntityWithChilds);

    commentViewModel =
        EntityFactory.makeExpansibleGroupFromProductViewModel(selected: true);
    printRequestEntity = EntityFactory.makePrintRequestEntity();
    saleRequestEntity = EntityFactory.makeSaleRequestEntity();
    saleRequestModel = SaleRequestModel.fromEntity(saleRequestEntity);
    homePresenter.commandEntityController = CommandEntity(
      commandNumber:
          faker.randomGenerator.integer(100).toString().padLeft(3, "0"),
      isFixedCommandNumber: true,
      pdv: EntityFactory.makePdvEntity(),
    );
  }

  void initMockSuccess() {
    loadSaleRequestTemp.mockLoadSaleRequestTemp(saleRequestTempEntity);
    localPrintRequest.mockGetMergedPrinted(null);
    cartInformations.mockSaveCart([cartProductViewModelWithChilds]);
    cartInformations.mockGetCart([cartProductViewModelWithChilds]);
    barcodeScanner.mockBarcodeScanner(
        homePresenter.commandEntityController!.commandNumber!);
    loadSaleRequest.mockLoadSaleRequest(saleRequestModel);
  }

  setUp(() {
    initUsecases();
    initPresenters();
    initEntitys();
    initMockSuccess();
  });

  setUpAll(() {
    registerFallbackValue(EntityFactory.makeSaleRequestTempEntity(null));
    registerFallbackValue(EntityFactory.makePrintRequestEntity());
    registerFallbackValue(EntityFactory.makeUpdateSaleRequestTempEntity());
    registerFallbackValue(EntityFactory.makeProductsViewModel());
    registerFallbackValue(EntityFactory.makeProductCompositionViewModel(
      quantity: faker.randomGenerator.decimal(),
      salePrice: faker.randomGenerator.decimal(),
      offerPrice: faker.randomGenerator.decimal(),
      fatherIncrement: faker.randomGenerator.decimal(),
      childIncrement: faker.randomGenerator.decimal(),
      indexOfSelectedChild: faker.randomGenerator.integer(10),
      isOptionalItem: faker.randomGenerator.boolean(),
      insertChilds: faker.randomGenerator.boolean(),
    ));
    registerFallbackValue(
        EntityFactory.makeExpansibleGroupFromProductViewModel());
    registerFallbackValue(ExpansibleGroupFromProductPresenterSpy());
    registerFallbackValue(HomePresenterSpy());
    registerFallbackValue(PrintedProductsPresenterSpy());
    registerFallbackValue(CartPresenterSpy());
    registerFallbackValue(MenuPresenterSpy());
    registerFallbackValue(UpdateSaleRequestTempEntity);
    registerFallbackValue(
        EntityFactory.makeExpansibleGroupFromProductViewModel());
  });

  group("CartInformations", () {
    test(
        "Should call updateCartInformations on addProductInCart with correct quantity",
        () async {
      await sut.addProductInCart(
        product: cartProductEntityWithChilds,
        menuPresenter: menuPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );

      verify(
        () => cartInformations
            .updateCartProducts([cartProductViewModelWithChilds]),
      ).called(1);
    });

    test("Should not add product in cart if cartInformations.update throws",
        () async {
      cartInformations.mockSaveError();

      await sut.addProductInCart(
        product: cartProductEntityWithChilds,
        menuPresenter: menuPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );

      expect(sut.cartProducts, []);
    });
    test("Should emit correct events on addProductInCart success", () async {
      expectLater(sut.mainErrorStream, emits(null));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.addProductInCart(
        product: cartProductEntityWithChilds,
        menuPresenter: menuPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );
    });
    test("Should emit correct events on addProductInCart throws", () async {
      cartInformations.mockSaveError();
      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.addProductInCart(
        product: cartProductEntityWithChilds,
        menuPresenter: menuPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );
    });

    test(
        "Should call cartInformations.update when removeProductFromCart succeeds",
        () async {
      await sut.addProductInCart(
        product: cartProductEntityWithChilds,
        menuPresenter: menuPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );
      await sut.removeProductFromCart(0);

      verify(
        () => cartInformations.updateCartProducts([
          CartProductsViewModel(
            Comments: null,
            Product: cartProductViewModelWithChilds.Product,
            TotalLiquid: cartProductViewModelWithChilds.TotalLiquid,
            Quantity: cartProductViewModelWithChilds.Quantity,
            Value: cartProductViewModelWithChilds.Value,
            ProductPriceLookUpCode:
                cartProductViewModelWithChilds.ProductPriceLookUpCode,
          )
        ]),
      ).called(1);
    });
    test(
        "Should NOT remove product from cart when cartInformations.update throws",
        () async {
      sut.cartProducts.add(cartProductViewModelWithChilds);

      cartInformations.mockSaveError();
      await sut.removeProductFromCart(0);

      expect(sut.cartProducts, [cartProductViewModelWithChilds]);
    });

    test("Should emit correct events on removeProductFromCart success",
        () async {
      expectLater(sut.mainErrorStream, emits(null));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      sut.cartProducts.add(cartProductViewModelWithChilds);

      await sut.removeProductFromCart(0);
    });
    test("Should emit correct events on removeProductFromCart throws",
        () async {
      cartInformations.mockSaveError();
      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      sut.cartProducts.add(cartProductViewModelWithChilds);

      await sut.removeProductFromCart(0);
    });
    test(
        "Should not remove product from cart when quantity is 1 and cartInformations.update throws",
        () async {
      sut.cartProducts.add(cartProductViewModelWithChilds);

      cartInformations.mockSaveError();
      await sut.reduceCartProductQuantity(0);

      expect(sut.cartProducts.length, 1);
    });
    test(
        "Should not reduce productQuantity when cartInformations.update throws",
        () async {
      sut.cartProducts.add(cartProductViewModelWithChilds);

      cartInformations.mockSaveError();
      await sut.reduceCartProductQuantity(0);

      expect(
        sut.cartProducts.first.Quantity.toDouble(),
        cartProductEntityWithChilds.Quantity,
      );
    });

    test("Should reduce productQuantity when cartInformations.update succeeds",
        () async {
      sut.cartProducts.add(cartProductViewModelWithChilds);

      await sut.reduceCartProductQuantity(0);

      expect(
        sut.cartProducts.first.Quantity.toDouble(),
        cartProductEntityWithChilds.Quantity - 1,
      );
    });
    test("Should emit correct values on reduceCartProductQuantity succeeds",
        () async {
      expectLater(sut.mainErrorStream, emits(null));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.reduceCartProductQuantity(0);
    });
    test("Should emit correct values on reduceCartProductQuantity throws",
        () async {
      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      cartInformations.mockSaveError();
      await sut.reduceCartProductQuantity(0);
    });
    test(
        "Should not addCartProductQuantity when cartInformations.update throws",
        () async {
      sut.cartProducts.add(cartProductViewModelWithChilds);

      cartInformations.mockSaveError();
      await sut.addCartProductQuantity(0);

      expect(
        sut.cartProducts.first.Quantity.toDouble(),
        cartProductEntityWithChilds.Quantity,
      );
    });

    test(
        "Should emit error to add quantity when new quantity is more than maximum quantity",
        () async {
      final cartProductEntity = EntityFactory.makeCartProductEntity(
        maximumProductQuantity: 2,
        minimumProductQuantity: 1,
        generateChilds: false,
      );
      sut.cartProducts.add(CartProductsViewModel.fromEntity(cartProductEntity));

      expectLater(
        sut.mainErrorStream,
        emitsInOrder([null, UIError.maximumQuantityAchieved]),
      );

      await sut.addCartProductQuantity(0);
      await sut.addCartProductQuantity(0);
    });

    test("Should addCartProductQuantity when cartInformations.update succeeds",
        () async {
      sut.cartProducts.add(cartProductViewModelWithChilds);

      await sut.addCartProductQuantity(0);

      expect(
        sut.cartProducts.first.Quantity.toDouble(),
        cartProductEntityWithChilds.Quantity + 1,
      );
    });
    test("Should emit correct values on addCartProductQuantity succeeds",
        () async {
      expectLater(sut.mainErrorStream, emits(null));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      sut.cartProducts.add(cartProductViewModelWithChilds);
      await sut.addCartProductQuantity(0);
    });
    test("Should emit correct values on addCartProductQuantity throws",
        () async {
      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      cartInformations.mockSaveError();
      sut.cartProducts.add(cartProductViewModelWithChilds);
      await sut.addCartProductQuantity(0);
    });

    test("Should call cartInformations.clear when saveProducts succeeds",
        () async {
      await sut.saveProducts(
        insertProductPresenter: insertProductPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
        printedProductsPresenter: printedProductsPresenter,
        tableNumber: tableNumber,
        homePresenter: homePresenter,
        commandNumber: homePresenter.commandEntityController!.commandNumber,
      );

      verify(() => cartInformations.clearCartProducts()).called(1);
    });

    test("Should call cartInformations.get on sut.getLocalCartProductsData",
        () async {
      await sut.getLocalCartProductsData();

      verify(
        () => cartInformations.getCartProducts(),
      ).called(1);
    });

    test("Should update cartProducts if contains data in local storage",
        () async {
      await sut.getLocalCartProductsData();

      expect(sut.cartProducts, [cartProductViewModelWithChilds]);
    });

    test("Should not update cartProducts if localData returns null", () async {
      cartInformations.mockGetCart(null);
      await sut.getLocalCartProductsData();

      expect(sut.cartProducts, []);
    });

    test("Should emit correct values on getLocalCartProductsData", () async {
      expectLater(sut.mainErrorStream, emits(null));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.getLocalCartProductsData();
    });

    test("Should emit correct values on getLocalCartProductsData", () async {
      cartInformations.mockGetError();

      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.getLocalCartProductsData();
    });

    test("Should call cartInformations.update on update cart comment",
        () async {
      sut.cartProducts.add(cartProductViewModelWithChilds);

      final newComment = faker.randomGenerator.string(10);
      await sut.updateCommentOfProductCart(
        index: 0,
        newComment: newComment,
      );

      final updatedProduct = [
        CartProductsViewModel(
          Product: cartProductViewModelWithChilds.Product,
          Comments: newComment,
          TotalLiquid: cartProductViewModelWithChilds.TotalLiquid,
          Quantity: cartProductViewModelWithChilds.Quantity,
          Value: cartProductViewModelWithChilds.Value,
          ProductPriceLookUpCode:
              cartProductViewModelWithChilds.ProductPriceLookUpCode,
        )
      ];

      verify(() => cartInformations.updateCartProducts(updatedProduct))
          .called(1);
      expect(sut.cartProducts, updatedProduct);
    });
    test("Should not update comment on cartInformations.update throws",
        () async {
      cartInformations.mockSaveError();
      sut.cartProducts.add(cartProductViewModelWithChilds);

      await sut.updateCommentOfProductCart(
        index: 0,
        newComment: comments,
      );

      expect(sut.cartProducts, [cartProductViewModelWithChilds]);
    });
    test("Should emit correct events on updateCartProductComment success",
        () async {
      expectLater(sut.mainErrorStream, emits(null));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      sut.cartProducts.add(cartProductViewModelWithChilds);
      await sut.updateCommentOfProductCart(
        index: 0,
        newComment: comments,
      );
    });
    test("Should emit correct events on updateCartProductComment throws",
        () async {
      cartInformations.mockSaveError();

      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      sut.cartProducts.add(cartProductViewModelWithChilds);
      await sut.updateCommentOfProductCart(
        index: 0,
        newComment: comments,
      );
    });
  });

  group("LoadSaleRequestTemp", () {
    test("Should update SaleRequestTemp correctly on LoadSaleRequestTemp",
        () async {
      await sut.getSaleRequestTemp(
          homePresenter.commandEntityController!.commandNumber!);

      expect(sut.saleRequestTemp,
          SaleRequestTempViewModel.fromEntity(saleRequestTempEntity));
    });

    test("Should emits correct events on LoadSaleRequestTemp throws", () async {
      loadSaleRequestTemp.mockError(DomainError.unexpected);

      final error = sut.getSaleRequestTemp(
          homePresenter.commandEntityController!.commandNumber!);

      expect(error, throwsA(DomainError.unexpected));
    });

    test(
        "Should emits correct events on ticketIsNotPermitted when LoadSaleRequestTemp",
        () async {
      loadSaleRequestTemp.mockError(DomainError.commandNotAvailable);

      final error = sut.getSaleRequestTemp(
          homePresenter.commandEntityController!.commandNumber!);

      expect(error, throwsA(DomainError.commandNotAvailable));
    });

    test("Should call LoadSaleRequestTemp with correct values", () async {
      await sut.getSaleRequestTemp(
          homePresenter.commandEntityController!.commandNumber!);

      verify(() => loadSaleRequestTemp.load(
          url: EnterpriseBuilder.entity!.url!,
          enterpriseId: EnterpriseBuilder.entity!.enterpriseId!,
          commandNumber:
              homePresenter.commandEntityController!.commandNumber!)).called(1);
    });
  });

  group("Add PrintRequest", () {
    test("Should call addPrintRequest when save products", () async {
      await sut.saveProducts(
        insertProductPresenter: insertProductPresenter,
        printedProductsPresenter: printedProductsPresenter,
        tableNumber: tableNumber,
        homePresenter: homePresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );

      verify(
        () => addPrintRequest.add(printRequestEntity),
      ).called(1);
    });

    test(
        "Should call correct printRequests when finish success and has printRequestEntity in local data",
        () async {
      localPrintRequest.mockGetMergedPrinted(printRequestEntity);

      await sut.saveProducts(
        insertProductPresenter: insertProductPresenter,
        printedProductsPresenter: printedProductsPresenter,
        tableNumber: tableNumber,
        homePresenter: homePresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );

      verify(
        () => localPrintRequest.getLocalPrintedEntity(),
      ).called(1);
      verify(
        () => localPrintRequest.clear(),
      ).called(1);
      verify(
        () => addPrintRequest.add(
          PrintRequestEntity(
            dates: [
              ...printRequestEntity.dates,
              "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}",
            ],
            timesUsed: printRequestEntity.timesUsed + 1,
          ),
        ),
      ).called(1);
    });

    test(
        "Should call correct printRequests when finish success and dont have printRequestEntity in local data",
        () async {
      await sut.saveProducts(
        insertProductPresenter: insertProductPresenter,
        printedProductsPresenter: printedProductsPresenter,
        tableNumber: tableNumber,
        homePresenter: homePresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );

      verify(
        () => localPrintRequest.getLocalPrintedEntity(),
      ).called(1);
      verify(
        () => localPrintRequest.clear(),
      ).called(1);
      verify(
        () => addPrintRequest.add(printRequestEntity),
      ).called(1);
    });

    test("Should call correct printRequests when finish throw", () async {
      finishSaleRequestTempById.mockFinishError();

      await sut.saveProducts(
        insertProductPresenter: insertProductPresenter,
        printedProductsPresenter: printedProductsPresenter,
        tableNumber: tableNumber,
        homePresenter: homePresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );

      verify(
        () => localPrintRequest.getLocalPrintedEntity(),
      ).called(1);
      verify(
        () => localPrintRequest.clear(),
      ).called(1);
      verify(
        () => addPrintRequest.add(printRequestEntity),
      ).called(1);
    });

    test("Should call LocalAddPrintRequest when addPrintRequest throws",
        () async {
      addPrintRequest.mockRemoteAddError();

      await sut.saveProducts(
        insertProductPresenter: insertProductPresenter,
        printedProductsPresenter: printedProductsPresenter,
        tableNumber: tableNumber,
        homePresenter: homePresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );

      verify(
        () => localPrintRequest.add(printRequestEntity),
      ).called(1);
    });

    test(
        "Should call LocalAddPrintRequest when localPrintRequest.GetMergedPrint throws",
        () async {
      localPrintRequest.mockGetMergedPrintedError();

      await sut.saveProducts(
        insertProductPresenter: insertProductPresenter,
        printedProductsPresenter: printedProductsPresenter,
        tableNumber: tableNumber,
        homePresenter: homePresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );

      verify(
        () => localPrintRequest.add(printRequestEntity),
      ).called(1);
    });
  });

  group("Cart products", () {
    test("Should add correctly CartProduct", () async {
      expect(sut.cartProducts, []);

      await sut.addProductInCart(
        product: cartProductEntityWithChilds,
        menuPresenter: menuPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );

      expect(sut.cartProducts, [cartProductViewModelWithChilds]);
    });
    test("Should remove correct product from cart", () async {
      expect(sut.cartProducts, []);
      final cartProduct1 = EntityFactory.makeCartProductEntity(
        maximumProductQuantity: 100, //tanto faz pra esse teste
        minimumProductQuantity: 1, //tanto faz pra esse teste
      );

      await sut.addProductInCart(
        product: cartProductEntityWithChilds,
        menuPresenter: menuPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );
      await sut.addProductInCart(
        product: cartProduct1,
        menuPresenter: menuPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );

      expect(sut.cartProducts, [
        cartProductViewModelWithChilds, //0
        CartProductsViewModel.fromEntity(cartProduct1), //1
      ]);

      await sut.removeProductFromCart(0);
      expect(
          sut.cartProducts, [CartProductsViewModel.fromEntity(cartProduct1)]);

      await sut.removeProductFromCart(0);
      expect(sut.cartProducts, []);
    });

    test("Should update comment correctly", () async {
      sut.cartProducts.add(cartProductViewModelWithChilds);
      final newComment = faker.randomGenerator.string(20);

      await sut.updateCommentOfProductCart(index: 0, newComment: newComment);

      final cartProductWithNewComment = CartProductsViewModel(
        Comments: newComment,
        Product: cartProductViewModelWithChilds.Product,
        TotalLiquid: cartProductViewModelWithChilds.TotalLiquid,
        Quantity: cartProductViewModelWithChilds.Quantity,
        Value: cartProductViewModelWithChilds.Value,
        ProductPriceLookUpCode:
            cartProductViewModelWithChilds.ProductPriceLookUpCode,
      );

      expect(sut.cartProducts, [cartProductWithNewComment]);
    });
    test("Should NOT update comment when new comment is equal", () async {
      sut.cartProducts.add(cartProductViewModelWithChilds);

      await sut.updateCommentOfProductCart(
        index: 0,
        newComment: cartProductViewModelWithChilds.Comments,
      );

      verifyNever(() => cartInformations
          .updateCartProducts([cartProductViewModelWithChilds]));
    });
    test("Should update comment with null value if comment is empty", () async {
      sut.cartProducts.add(cartProductViewModelWithChilds);

      await sut.updateCommentOfProductCart(
        index: 0,
        newComment: "",
      );

      verify(() => cartInformations.updateCartProducts(
            [
              CartProductsViewModel(
                Product: cartProductViewModelWithChilds.Product,
                Comments: null,
                TotalLiquid: cartProductViewModelWithChilds.TotalLiquid,
                Quantity: cartProductViewModelWithChilds.Quantity,
                Value: cartProductViewModelWithChilds.Value,
                ProductPriceLookUpCode:
                    cartProductViewModelWithChilds.ProductPriceLookUpCode,
              ),
            ],
          )).called(1);
    });

    test("Should reduce quantity correctly", () async {
      await sut.addProductInCart(
        product: cartProductEntityWithChilds,
        menuPresenter: menuPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );
      await sut.addProductInCart(
        product: cartProductWithOneQuantity,
        menuPresenter: menuPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );

      await sut.reduceCartProductQuantity(0);
      expect(sut.cartProducts[0].Quantity,
          (cartProductEntityWithChilds.Quantity - 1).toString());

      await sut.reduceCartProductQuantity(1);
      expect(sut.cartProducts.length, 1);
    });

    test("Should update totalLiquid correctly when reduce quantity", () async {
      await sut.addProductInCart(
        product: cartProductEntityWithChilds,
        menuPresenter: menuPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );
      expect(sut.cartProducts[0].TotalLiquid,
          cartProductEntityWithChilds.TotalLiquid.toString());

      await sut.reduceCartProductQuantity(0);
      expect(
        sut.cartProducts[0].TotalLiquid,
        (cartProductEntityWithChilds.Value *
                (cartProductEntityWithChilds.Quantity - 1))
            .toString(),
      );
    });

    test("Should add quantity correctly", () async {
      await sut.addProductInCart(
        product: cartProductEntityWithChilds,
        menuPresenter: menuPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );

      await sut.addCartProductQuantity(0);

      expect(sut.cartProducts[0].Quantity,
          (cartProductEntityWithChilds.Quantity + 1).toString());
    });

    test("Should update totalLiquid correctly when add quantity", () async {
      await sut.addProductInCart(
        product: cartProductEntityWithChilds,
        menuPresenter: menuPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );
      expect(sut.cartProducts[0].TotalLiquid,
          cartProductEntityWithChilds.TotalLiquid.toString());

      await sut.addCartProductQuantity(0);
      expect(
        sut.cartProducts[0].TotalLiquid,
        (cartProductEntityWithChilds.Value *
                (cartProductEntityWithChilds.Quantity + 1))
            .toString(),
      );
    });

    test("Should clear indexOfSelectedProduct when add a product", () async {
      await sut.addProductInCart(
        product: cartProductEntityWithChilds,
        menuPresenter: menuPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );

      expect(sut.indexOfSelectedProduct, null);
    });

    test(
        "Should add new product in cart if already contains equal PLU in cart but the comment is differente",
        () async {
      expansibleGroupFromProductPresenter
          .mockGetConcatenateSelectedComments(faker.randomGenerator.string(10));
//o comentário que é adicionado, é o que retorna nessa função do
//expansibleGroupFromProductPresenter, por isso precisa mockar o retorno da função
      await sut.addProductInCart(
        product: cartProductEntityWithChilds,
        menuPresenter: menuPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );

      expansibleGroupFromProductPresenter
          .mockGetConcatenateSelectedComments(faker.randomGenerator.string(10));
      await sut.addProductInCart(
        product: cartProductEntityWithChilds,
        menuPresenter: menuPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );

      expect(sut.cartProducts.length, 2);
    });

    test(
        "Should add new product in cart if already contains equal PLU in cart but the value is differente",
        () async {
      await sut.addProductInCart(
        product: cartProductEntityWithChilds,
        menuPresenter: menuPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );

      final productWithNewComment = CartProductEntity(
        Product: cartProductEntityWithChilds.Product,
        Comments: cartProductEntityWithChilds.Comments,
        TotalLiquid: cartProductEntityWithChilds.TotalLiquid,
        Quantity: cartProductEntityWithChilds.Quantity,
        Value: 726871278512785348193219.0,
        ProductPriceLookUpCode:
            cartProductEntityWithChilds.ProductPriceLookUpCode,
      );
      await sut.addProductInCart(
        product: productWithNewComment,
        menuPresenter: menuPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );

      expect(sut.cartProducts.length, 2);
    });

    test("Should add product with correct comment in cart", () async {
      expansibleGroupFromProductPresenter.mockGetConcatenateSelectedComments(
          "${commentViewModel.GroupName}\n${commentViewModel.GroupName}");

      await sut.addProductInCart(
        product: cartProductEntityWithChilds,
        menuPresenter: menuPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );

      expect(sut.cartProducts, [
        CartProductsViewModel(
          Comments:
              "${commentViewModel.GroupName}\n${commentViewModel.GroupName}",
          Product: cartProductViewModelWithChilds.Product,
          TotalLiquid: cartProductEntityWithChilds.TotalLiquid.toString(),
          Quantity: cartProductEntityWithChilds.Quantity.toString(),
          Value: cartProductEntityWithChilds.Value.toString(),
          ProductPriceLookUpCode:
              cartProductEntityWithChilds.ProductPriceLookUpCode,
        ),
      ]);
    });

    test("Should clear cartProducts on call clearCartAndConfirmedCombox",
        () async {
      sut.cartProducts.add(cartProductViewModelWithChilds);
      await sut.clearCart();

      expect(sut.cartProducts, []);
    });

    test(
        "Should call cartInformations.clearCartProducts() on clearCartAndConfirmedCombox",
        () async {
      await sut.clearCart();

      verify(() => cartInformations.clearCartProducts()).called(1);
    });

    test(
        "Should call cartInformations.clearCartProduct on clearCartAndConfirmedCombox",
        () async {
      await sut.clearCart();

      verify(() => cartInformations.clearCartProducts()).called(1);
    });
    test("Should emit correct values on clearCartAndConfirmedCombox success",
        () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.mainErrorStream, emits(null));

      await sut.clearCart();
    });
    test("Should emit correct values on clearCartAndConfirmedCombox throws",
        () async {
      cartInformations.mockClearError();

      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));

      await sut.clearCart();
    });
  });

  group("Save products", () {
    test("Should call correct functions on save products in SaleRequestTemp",
        () async {
      cartProductViewModelWithChilds.Product.childsComposition = null;

      sut.cartProducts.add(cartProductViewModelWithChilds);
      confirmedCartProducts.mockIsConfirmed(false);

      await sut.saveProducts(
        insertProductPresenter: insertProductPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
        printedProductsPresenter: printedProductsPresenter,
        tableNumber: tableNumber,
        homePresenter: homePresenter,
        commandNumber: homePresenter.commandEntityController!.commandNumber,
      );

      verify(
        () => loadSaleRequestTemp.load(
          url: EnterpriseBuilder.entity!.url!,
          enterpriseId: EnterpriseBuilder.entity!.enterpriseId!,
          commandNumber: homePresenter.commandEntityController!.commandNumber!,
        ),
      ).called(1);

      verify(() => confirmedCartProducts.isConfirmed()).called(1);
      verify(() => confirmedCartProducts.updateValue(true)).called(1);
      verify(() => confirmedCartProducts.updateValue(false)).called(1);

      final teste = UpdateSaleRequestTempEntity(
        Peoples: updateSaleRequestTempEntity.Peoples,
        SellerCode: updateSaleRequestTempEntity.SellerCode,
        Comments: updateSaleRequestTempEntity.Comments,
        DeliveryControl: updateSaleRequestTempEntity.DeliveryControl,
        EnterpriseId: updateSaleRequestTempEntity.EnterpriseId,
        PersonalizedCode: updateSaleRequestTempEntity.PersonalizedCode,
        SaleRequestTempId: updateSaleRequestTempEntity.SaleRequestTempId,
        CovenantCode: updateSaleRequestTempEntity.CovenantCode,
        CustomerCode: updateSaleRequestTempEntity.CustomerCode,
        TotalLiquid: cartProductViewModelWithChilds.TotalLiquid.toDouble(),
        IncrementValue:
            EnterpriseBuilder.entity?.serviceChargePercentageOrValue,
        IncrementType: EnterpriseBuilder.entity?.serviceChargeType,
        Products: [
          UpdateSaleRequestTempProductEntity(
            ProductInternalCodeOnErp: cartProductViewModelWithChilds
                .Product.InternalCodeOnERP!
                .toInt(),
            ProductPriceLookUpCode:
                cartProductViewModelWithChilds.ProductPriceLookUpCode,
            Quantity: cartProductViewModelWithChilds.Quantity.toDouble(),
            SaleRequestTempId: updateSaleRequestTempEntity.SaleRequestTempId,
            TotalLiquid: cartProductViewModelWithChilds.TotalLiquid.toDouble(),
            Value: cartProductViewModelWithChilds.Value.toDouble(),
            Comments: cartProductViewModelWithChilds.Comments,
            SaleRequestProductIdOfFather: null,
            ProductIsFatherComposition: false,
          )
        ],
      );

      verify(() => updateSaleRequestTemp.update(
            url: EnterpriseBuilder.entity!.url!,
            entity: teste,
          )).called(1);

      verify(() => finishSaleRequestTempById.finish(
            saleRequestTempEntity.SaleRequestTempId,
          )).called(1);
      verify(() => printedProductsPresenter.loadPrinted(
          homePresenter.commandEntityController!.commandNumber!)).called(1);
    });
    test(
        "Should convert correctly combox products to UpdateSaleRequestTempProductEntity on saveProducts",
        () async {
      for (var child
          in cartProductViewModelWithChilds.Product.childsComposition!) {
        child.indexOfSelectedChild = 0;
      }
      sut.cartProducts.add(cartProductViewModelWithChilds);

      final products = sut.getProductsEntitys(
        saleRequestTempId: updateSaleRequestTempEntity.SaleRequestTempId,
        insertProductPresenter: insertProductPresenter,
      );

      await sut.saveProducts(
        insertProductPresenter: insertProductPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
        printedProductsPresenter: printedProductsPresenter,
        tableNumber: tableNumber,
        homePresenter: homePresenter,
        commandNumber: homePresenter.commandEntityController!.commandNumber,
      );

      final totalLiquid = products
          .where((e) => e.ProductIsFatherComposition == false)
          .fold(0.0,
              (previousValue, element) => element.TotalLiquid + previousValue);
      final entity = UpdateSaleRequestTempEntity(
        Peoples: updateSaleRequestTempEntity.Peoples,
        SellerCode: updateSaleRequestTempEntity.SellerCode,
        Comments: updateSaleRequestTempEntity.Comments,
        DeliveryControl: updateSaleRequestTempEntity.DeliveryControl,
        EnterpriseId: updateSaleRequestTempEntity.EnterpriseId,
        PersonalizedCode: updateSaleRequestTempEntity.PersonalizedCode,
        SaleRequestTempId: updateSaleRequestTempEntity.SaleRequestTempId,
        CustomerCode: updateSaleRequestTempEntity.CustomerCode,
        CovenantCode: updateSaleRequestTempEntity.CovenantCode,
        IncrementValue:
            EnterpriseBuilder.entity?.serviceChargePercentageOrValue,
        IncrementType: EnterpriseBuilder.entity?.serviceChargeType,
        TotalLiquid: totalLiquid,
        Products: [...products],
      );

      verify(() => updateSaleRequestTemp.update(
            url: EnterpriseBuilder.entity!.url!,
            entity: entity,
          )).called(1);
    });

    test("Should emit correct values on success to save cart products",
        () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.mainErrorStream, emits(null));

      await sut.saveProducts(
        insertProductPresenter: insertProductPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
        printedProductsPresenter: printedProductsPresenter,
        tableNumber: tableNumber,
        homePresenter: homePresenter,
        commandNumber: homePresenter.commandEntityController!.commandNumber,
      );
    });
    // test("Should emit correct values on BarcodeScanner throws unexpected",
    //     () async {
    //   barcodeScanner.mockError(DomainError.unexpected);

    //   expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    //   expectLater(
    //       sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));

    //   await sut.saveProducts(
    //     insertProductPresenter: insertProductPresenter,
    //     expansibleGroupFromProductPresenter:
    //         expansibleGroupFromProductPresenter,
    //     printedProductsPresenter: printedProductsPresenter,
    //     tableNumber: tableNumber,
    //     homePresenter: homePresenter,
    //     commandNumber: homePresenter.commandEntityController!.commandNumber,
    //   );
    // });
    // test("Should emit correct values on BarcodeScanner throws BarcodeNotRead",
    //     () async {
    //   barcodeScanner.mockError(DomainError.barcodeNotRead);

    //   expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    //   expectLater(
    //       sut.mainErrorStream, emitsInOrder([null, UIError.barcodeNotRead]));

    //   await sut.saveProducts(
    //     insertProductPresenter: insertProductPresenter,
    //     expansibleGroupFromProductPresenter:
    //         expansibleGroupFromProductPresenter,
    //     printedProductsPresenter: printedProductsPresenter,
    //     tableNumber: tableNumber,
    //     homePresenter: homePresenter,
    //     commandNumber: homePresenter.commandEntityController!.commandNumber,
    //   );
    // });
    test("Should emit correct values LoadSaleRequestTemp throws", () async {
      loadSaleRequestTemp.mockError(DomainError.unexpected);

      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));

      await sut.saveProducts(
        insertProductPresenter: insertProductPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
        printedProductsPresenter: printedProductsPresenter,
        tableNumber: tableNumber,
        homePresenter: homePresenter,
      );
    });
    test("Should call correct functions LoadSaleRequestTemp throws", () async {
      loadSaleRequestTemp.mockError(DomainError.unexpected);

      await sut.saveProducts(
        insertProductPresenter: insertProductPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
        printedProductsPresenter: printedProductsPresenter,
        tableNumber: tableNumber,
        homePresenter: homePresenter,
      );

      verify(
        () => loadSaleRequestTemp.load(
          url: EnterpriseBuilder.entity!.url!,
          enterpriseId: EnterpriseBuilder.entity!.enterpriseId!,
          commandNumber: homePresenter.commandEntityController!.commandNumber!,
        ),
      ).called(1);

      verifyNever(() => confirmedCartProducts.isConfirmed());
      verifyNever(() => confirmedCartProducts.updateValue(true));
      verifyNever(() => confirmedCartProducts.updateValue(false));

      verifyNever(() => updateSaleRequestTemp.update(
            url: EnterpriseBuilder.entity!.url!,
            entity: updateSaleRequestTempEntity,
          ));

      verifyNever(() => finishSaleRequestTempById.finish(
            saleRequestTempEntity.SaleRequestTempId,
          ));
    });
    test("Should emit correct values LoadSaleRequestTemp throws", () async {
      loadSaleRequestTemp.mockError(DomainError.unexpected);

      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));

      await sut.saveProducts(
        insertProductPresenter: insertProductPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
        printedProductsPresenter: printedProductsPresenter,
        tableNumber: tableNumber,
        homePresenter: homePresenter,
      );
    });
    test("Should call correct functions when LoadSaleRequestTemp throws",
        () async {
      loadSaleRequestTemp.mockError(DomainError.unexpected);

      await sut.saveProducts(
        insertProductPresenter: insertProductPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
        printedProductsPresenter: printedProductsPresenter,
        tableNumber: tableNumber,
        homePresenter: homePresenter,
      );

      verify(
        () => loadSaleRequestTemp.load(
          url: EnterpriseBuilder.entity!.url!,
          enterpriseId: EnterpriseBuilder.entity!.enterpriseId!,
          commandNumber: homePresenter.commandEntityController!.commandNumber!,
        ),
      ).called(1);

      verifyNever(() => confirmedCartProducts.isConfirmed());
      verifyNever(() => confirmedCartProducts.updateValue(true));
      verifyNever(() => confirmedCartProducts.updateValue(false));

      verifyNever(() => updateSaleRequestTemp.update(
            url: EnterpriseBuilder.entity!.url!,
            entity: updateSaleRequestTempEntity,
          ));

      verifyNever(() => finishSaleRequestTempById.finish(
            saleRequestTempEntity.SaleRequestTempId,
          ));
    });
    test("Should emit correct values updateSaleRequestTemp throws", () async {
      updateSaleRequestTemp
          .mockUpdateSaleRequestTempError(DomainError.unexpected);

      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));

      confirmedCartProducts.mockIsConfirmed(false);
      await sut.saveProducts(
        insertProductPresenter: insertProductPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
        printedProductsPresenter: printedProductsPresenter,
        tableNumber: tableNumber,
        homePresenter: homePresenter,
      );
    });
    test("Should call correct functions updateSaleRequestTemp throws",
        () async {
      updateSaleRequestTemp
          .mockUpdateSaleRequestTempError(DomainError.unexpected);
      confirmedCartProducts.mockIsConfirmed(false);

      await sut.saveProducts(
        insertProductPresenter: insertProductPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
        printedProductsPresenter: printedProductsPresenter,
        tableNumber: tableNumber,
        homePresenter: homePresenter,
      );

      verify(
        () => loadSaleRequestTemp.load(
          url: EnterpriseBuilder.entity!.url!,
          enterpriseId: EnterpriseBuilder.entity!.enterpriseId!,
          commandNumber: homePresenter.commandEntityController!.commandNumber!,
        ),
      ).called(1);

      verify(() => updateSaleRequestTemp.update(
            url: EnterpriseBuilder.entity!.url!,
            entity: updateSaleRequestTempEntity,
          )).called(1);

      verify(() => confirmedCartProducts.isConfirmed()).called(1);
      verifyNever(() => confirmedCartProducts.updateValue(true));
      verifyNever(() => confirmedCartProducts.updateValue(false));

      verifyNever(() => finishSaleRequestTempById.finish(
            saleRequestTempEntity.SaleRequestTempId,
          ));
    });
    test("Should emit correct values finishSaleRequestTemp throws", () async {
      finishSaleRequestTempById.mockFinishError();

      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));

      await sut.saveProducts(
        insertProductPresenter: insertProductPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
        printedProductsPresenter: printedProductsPresenter,
        tableNumber: tableNumber,
        homePresenter: homePresenter,
      );
    });
    test("Should call correct functions when finishSaleRequestTemp throws",
        () async {
      finishSaleRequestTempById.mockFinishError();

      await sut.saveProducts(
        insertProductPresenter: insertProductPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
        printedProductsPresenter: printedProductsPresenter,
        tableNumber: tableNumber,
        homePresenter: homePresenter,
      );

      verify(
        () => loadSaleRequestTemp.load(
          url: EnterpriseBuilder.entity!.url!,
          enterpriseId: EnterpriseBuilder.entity!.enterpriseId!,
          commandNumber: homePresenter.commandEntityController!.commandNumber!,
        ),
      ).called(1);

      verify(() => updateSaleRequestTemp.update(
            url: EnterpriseBuilder.entity!.url!,
            entity: updateSaleRequestTempEntity,
          )).called(1);

      verify(() => finishSaleRequestTempById.finish(
            saleRequestTempEntity.SaleRequestTempId,
          )).called(1);

      verify(() => confirmedCartProducts.isConfirmed()).called(1);
      verify(() => confirmedCartProducts.updateValue(true)).called(1);
      verifyNever(() => confirmedCartProducts.updateValue(false));
    });

    test(
        "Should call verify is confirmed cart products when call saveCartProducts",
        () async {
      await sut.saveProducts(
        insertProductPresenter: insertProductPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
        printedProductsPresenter: printedProductsPresenter,
        tableNumber: tableNumber,
        homePresenter: homePresenter,
      );

      verify(() => confirmedCartProducts.isConfirmed()).called(1);
    });
    test(
        "Should call udpate confirmedCartProducts with true value when saveCartProducts succeeds",
        () async {
      await sut.saveProducts(
        insertProductPresenter: insertProductPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
        printedProductsPresenter: printedProductsPresenter,
        tableNumber: tableNumber,
        homePresenter: homePresenter,
      );

      verify(() => confirmedCartProducts.updateValue(true)).called(1);
    });
    test(
        "Should NOT call udpate confirmedCartProducts with true value when updateSaleRequest throws",
        () async {
      confirmedCartProducts.mockIsConfirmed(false);
      updateSaleRequestTemp
          .mockUpdateSaleRequestTempError(DomainError.unexpected);
      await sut.saveProducts(
        insertProductPresenter: insertProductPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
        printedProductsPresenter: printedProductsPresenter,
        tableNumber: tableNumber,
        homePresenter: homePresenter,
      );

      verifyNever(() => confirmedCartProducts.updateValue(true));
    });
    test(
        "Should call udpate confirmedCartProducts with false value when finishSaleRequestTemp succeeds",
        () async {
      await sut.saveProducts(
        insertProductPresenter: insertProductPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
        printedProductsPresenter: printedProductsPresenter,
        tableNumber: tableNumber,
        homePresenter: homePresenter,
      );

      verify(() => confirmedCartProducts.updateValue(false)).called(1);
    });
    test(
        "Should NOT call udpate confirmedCartProducts with false value when finishSaleRequestTemp throws",
        () async {
      finishSaleRequestTempById.mockFinishError();

      await sut.saveProducts(
        insertProductPresenter: insertProductPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
        printedProductsPresenter: printedProductsPresenter,
        tableNumber: tableNumber,
        homePresenter: homePresenter,
      );

      verifyNever(() => confirmedCartProducts.updateValue(false));
    });
    test(
        "Should not call updateSaleRequestTemp when confirmedCartProducts return true",
        () async {
      confirmedCartProducts.mockIsConfirmed(true);
      await sut.saveProducts(
        insertProductPresenter: insertProductPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
        printedProductsPresenter: printedProductsPresenter,
        tableNumber: tableNumber,
        homePresenter: homePresenter,
      );

      verifyNever(() => updateSaleRequestTemp.update(
            url: EnterpriseBuilder.entity!.url!,
            entity: updateSaleRequestTempEntity,
          ));
    });
    test(
        "Should call updateSaleRequestTemp when confirmedCartProducts return false",
        () async {
      confirmedCartProducts.mockIsConfirmed(false);
      await sut.saveProducts(
        insertProductPresenter: insertProductPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
        printedProductsPresenter: printedProductsPresenter,
        tableNumber: tableNumber,
        homePresenter: homePresenter,
      );

      verify(() => updateSaleRequestTemp.update(
            url: EnterpriseBuilder.entity!.url!,
            entity: updateSaleRequestTempEntity,
          )).called(1);
    });
    test(
        "Should call updateSaleRequestTemp when confirmedCartProducts return null",
        () async {
      confirmedCartProducts.mockIsConfirmed(null);
      await sut.saveProducts(
        insertProductPresenter: insertProductPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
        printedProductsPresenter: printedProductsPresenter,
        tableNumber: tableNumber,
        homePresenter: homePresenter,
      );

      verify(() => updateSaleRequestTemp.update(
            url: EnterpriseBuilder.entity!.url!,
            entity: updateSaleRequestTempEntity,
          )).called(1);
    });
    test("Should clear cartProducts on saveProducts succeeds", () async {
      sut.addProductInCart(
        product: cartProductEntityWithChilds,
        menuPresenter: menuPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );

      await sut.saveProducts(
        insertProductPresenter: insertProductPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
        printedProductsPresenter: printedProductsPresenter,
        tableNumber: tableNumber,
        homePresenter: homePresenter,
      );

      expect(sut.cartProducts, []);
    });
    test("Should return true on saveProducts succeeds", () async {
      final isUpdated = await sut.saveProducts(
        insertProductPresenter: insertProductPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
        printedProductsPresenter: printedProductsPresenter,
        tableNumber: tableNumber,
        homePresenter: homePresenter,
      );

      expect(isUpdated, true);
    });
    test("Should return false on saveProducts throws", () async {
      loadSaleRequestTemp.mockError(DomainError.unexpected);

      final isUpdated = await sut.saveProducts(
        insertProductPresenter: insertProductPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
        printedProductsPresenter: printedProductsPresenter,
        tableNumber: tableNumber,
        homePresenter: homePresenter,
      );

      expect(isUpdated, false);
    });

    test("Should return false on saveProducts throws", () async {
      loadSaleRequestTemp.mockError(DomainError.unexpected);

      final isUpdated = await sut.saveProducts(
        insertProductPresenter: insertProductPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
        printedProductsPresenter: printedProductsPresenter,
        tableNumber: tableNumber,
        homePresenter: homePresenter,
      );

      expect(isUpdated, false);
    });

    test(
        "Should not call barcodeScanner.read if homePresenter.isFixedCommandNumber",
        () async {
      expect(homePresenter.commandEntity?.isFixedCommandNumber, true);

      await sut.saveProducts(
        insertProductPresenter: insertProductPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
        printedProductsPresenter: printedProductsPresenter,
        tableNumber: tableNumber,
        homePresenter: homePresenter,
      );

      verifyNever(() => barcodeScanner.read());
    });
    test(
        "Should use homePresenter.commandNumber to saveProducts when isFixedCommandNumber",
        () async {
      final fixedCommandNumber = faker.randomGenerator.integer(999).toString();
      homePresenter.commandEntityController = CommandEntity(
        commandNumber: fixedCommandNumber,
        isFixedCommandNumber:
            homePresenter.commandEntityController!.isFixedCommandNumber,
        pdv: homePresenter.commandEntityController!.pdv,
      );
      expect(homePresenter.commandEntity!.commandNumber, fixedCommandNumber);

      await sut.saveProducts(
        insertProductPresenter: insertProductPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
        printedProductsPresenter: printedProductsPresenter,
        tableNumber: tableNumber,
        homePresenter: homePresenter,
      );
    });
    test("Should emit correct values on is invalid datetime", () async {
      commandInformations.mockIsValidDateTime(false);

      expectLater(
        sut.mainErrorStream,
        emitsInOrder([null, UIError.blockedCommand]),
      );

      await sut.saveProducts(
        insertProductPresenter: insertProductPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
        printedProductsPresenter: printedProductsPresenter,
        tableNumber: tableNumber,
        homePresenter: homePresenter,
      );
    });
    test("Should not call loadSaleRequestTemp when is invalid datetime",
        () async {
      commandInformations.mockIsValidDateTime(false);

      await sut.saveProducts(
        insertProductPresenter: insertProductPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
        printedProductsPresenter: printedProductsPresenter,
        tableNumber: tableNumber,
        homePresenter: homePresenter,
      );

      verifyNever(
        () => loadSaleRequestTemp.load(
          url: EnterpriseBuilder.entity!.url!,
          enterpriseId: EnterpriseBuilder.entity!.enterpriseId!,
          commandNumber: homePresenter.commandEntityController!.commandNumber!,
        ),
      );
    });

    test(
        "Should emit error when dont is fixed command number and dont write command number in save products",
        () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
        sut.mainErrorStream,
        emitsInOrder([null, UIError.commandNumberObligatory]),
      );

      homePresenter.commandEntityController = CommandEntity(
        commandNumber: homePresenter.commandEntityController!.commandNumber,
        isFixedCommandNumber: false,
        pdv: homePresenter.commandEntityController!.pdv,
      );

      await sut.saveProducts(
        insertProductPresenter: insertProductPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
        printedProductsPresenter: printedProductsPresenter,
        tableNumber: tableNumber,
        homePresenter: homePresenter,
      );
    });
    test(
        "Should update command number when is not fixed command number and write command number",
        () async {
      homePresenter.commandEntityController = CommandEntity(
        commandNumber: homePresenter.commandEntityController!.commandNumber,
        isFixedCommandNumber: false,
        pdv: homePresenter.commandEntityController!.pdv,
      );
      String newCommandNumber = faker.randomGenerator.integer(100).toString();

      await sut.saveProducts(
        insertProductPresenter: insertProductPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
        printedProductsPresenter: printedProductsPresenter,
        tableNumber: tableNumber,
        homePresenter: homePresenter,
        commandNumber: newCommandNumber,
      );

      verify(() => homePresenter.updateCommandEntity(
            commandNumber: newCommandNumber,
            isFixedCommandNumber:
                homePresenter.commandEntityController?.isFixedCommandNumber ==
                    true,
            pdv: homePresenter.commandEntityController?.pdv,
          )).called(1);
    });
  });

  group("Confirmed combox products", () {
    test(
        "Should convert correctly convertProductsCompositionToUpdateSaleRequestTempProductEntity",
        () async {
      //esse teste é um pouco mais complexo, por isso vou explicar o que faço em cada parte

      //crio uma lista com 3 produtos. Sendo um opcional e sem índice de filho
      //selecionado. Por isso ele precisa ser ignorado e leva em consideração
      //somente os dois primeiros
      cartProductViewModelWithChilds.Product.childsComposition =
          productsSelectedsInCombox;
      final firstChild =
          cartProductViewModelWithChilds.Product.childsComposition![0];
      final secondChild =
          cartProductViewModelWithChilds.Product.childsComposition![1];

      await sut.addProductInCart(
        product: cartProductViewModelWithChilds.toEntity(),
        menuPresenter: menuPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );

      // sut.confirmedCombox.add(comboxWithSelectedProducts);
      //adiciono esse combo pra conseguir testar

      final fakeSaleRequestTempId = faker.randomGenerator.integer(10);
      //deixo o id randômico pra ter certeza que vai funcionar

      final entity = sut.getProductsEntitys(
        saleRequestTempId: fakeSaleRequestTempId,
        insertProductPresenter: insertProductPresenter,
      ); //converto o combo pra uma lista de produtos da forma que usa pra adicionar na comanda

      expect(entity, [
        UpdateSaleRequestTempProductEntity(
          ProductInternalCodeOnErp: cartProductViewModelWithChilds
              .toEntity()
              .Product
              .InternalCodeOnERP!
              .toInt(),
          ProductPriceLookUpCode:
              cartProductViewModelWithChilds.toEntity().ProductPriceLookUpCode,
          Quantity: cartProductViewModelWithChilds.Quantity.toDouble(),
          SaleRequestTempId: fakeSaleRequestTempId,
          TotalLiquid: cartProductViewModelWithChilds.TotalLiquid.toDouble(),
          Value: cartProductViewModelWithChilds.Value.toDouble(),
          Comments: cartProductViewModelWithChilds.Comments,
          ProductIsFatherComposition:
              cartProductViewModelWithChilds.Product.childsComposition !=
                      null &&
                  cartProductViewModelWithChilds
                      .Product.childsComposition!.isNotEmpty,
          SaleRequestProductIdOfFather: null,
        ),
        UpdateSaleRequestTempProductEntity(
          ProductInternalCodeOnErp:
              firstChild.InternalCodeOnERPCodeFather!.toInt(),
          ProductPriceLookUpCode: firstChild.PluChild!,
          Quantity: firstChild.Quantity!.toDouble(),
          SaleRequestTempId: fakeSaleRequestTempId,
          TotalLiquid: insertProductPresenter
                  .calculateProductCompositionTotalLiquid(product: firstChild) *
              firstChild.Quantity!.toDouble(),
          Value: insertProductPresenter
              .calculateProductCompositionPrice(firstChild),
          Comments: firstChild.commentFather,
          SaleRequestProductIdOfFather: 0,
          ProductIsFatherComposition: false,
        ),
        UpdateSaleRequestTempProductEntity(
          ProductInternalCodeOnErp:
              secondChild.InternalCodeOnERPCodeFather!.toInt(),
          ProductPriceLookUpCode: secondChild.PluChild!,
          Quantity: secondChild.Quantity!.toDouble(),
          SaleRequestTempId: fakeSaleRequestTempId,
          TotalLiquid: insertProductPresenter
                  .calculateProductCompositionTotalLiquid(product: firstChild) *
              firstChild.Quantity!.toDouble(),
          Value: insertProductPresenter
              .calculateProductCompositionPrice(firstChild),
          Comments: secondChild.commentFather,
          SaleRequestProductIdOfFather: 0,
          ProductIsFatherComposition: false,
        ),
      ]);
    });
  });

  group("Calculate service charge value", () {
    test("Should return correct value", () {
      final totalLiquid = faker.randomGenerator.decimal();

      final value = sut.calculateServiceChargeValue(totalLiquid);

      expect(
          value,
          totalLiquid *
              (EnterpriseBuilder.entity!.serviceChargePercentageOrValue! /
                  100));
    });
    test("Should return correct value", () {
      final oldEnterprise = EnterpriseBuilder.entity;
      EnterpriseBuilder.entity = EnterpriseEntity(
        enterpriseName: oldEnterprise!.enterpriseName,
        url: oldEnterprise.url,
        enterpriseId: oldEnterprise.enterpriseId,
        concentradorUrl: oldEnterprise.concentradorUrl,
        persistApp: oldEnterprise.persistApp,
        urlCCS: oldEnterprise.urlCCS,
        useCovenant: oldEnterprise.useCovenant,
        enterpriseConcentradorParametersEntity:
            oldEnterprise.enterpriseConcentradorParametersEntity,
        updateMenu: oldEnterprise.updateMenu,
        updateConcentratorEnterpriseData:
            oldEnterprise.updateConcentratorEnterpriseData,
        serviceChargePercentageOrValue: null,
        serviceChargeType: null,
        updateDevicesInformations: oldEnterprise.updateDevicesInformations,
        updateEnterprise: oldEnterprise.updateEnterprise,
        zoomImage: oldEnterprise.zoomImage,
        pendingDevicesToUpdate: oldEnterprise.pendingDevicesToUpdate,
        updatePendingDevices: oldEnterprise.updatePendingDevices,
        waitDaysToPreloadImages: oldEnterprise.waitDaysToPreloadImages,
        secondsPreloadingImages: oldEnterprise.secondsPreloadingImages,
        pluServiceCharge: oldEnterprise.pluServiceCharge,
        internalCodeOnErpServiceCharge:
            oldEnterprise.internalCodeOnErpServiceCharge,
      );
      final totalLiquid = faker.randomGenerator.decimal();
      final value = sut.calculateServiceChargeValue(totalLiquid);

      expect(value, 0);
    });
  });
}
