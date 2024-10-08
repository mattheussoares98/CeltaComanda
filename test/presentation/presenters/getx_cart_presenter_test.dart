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
  late FinishSaleRequestTempSpy finishSaleRequestTemp;
  late AddPrintRequestSpy addPrintRequest;
  late LocalPrintRequestSpy localPrintRequest;
  late UpdateSaleRequestTempSpy updateSaleRequestTemp;
  late ConfirmedCartProductsSpy confirmedCartProducts;
  late CartInformationsSpy cartInformations;
  late BarcodeScannerSpy barcodeScanner;
  late CommandInformationsSpy commandInformations;
  late AlreadyPaidSpy alreadyPaid;

  late SaleRequestTempEntity saleRequestTempEntity;
  late String comments;
  late CartProductEntity cartProductEntity;
  late String commandNumber;
  late UpdateSaleRequestTempEntity updateSaleRequestTempEntity;
  late List<UpdateSaleRequestTempProductEntity>
      cartSaleRequestTempProductsEntity;
  late CartProductsViewModel cartProductViewModel;
  late CartProductEntity cartProductWithOneQuantity;
  late List<ProductCompositionViewModel> productsSelectedsInCombox;
  late int tableNumber;
  late ExpansibleGroupFromProductViewModel commentViewModel;
  late PrintRequestEntity printRequestEntity;

  void initUsecases() {
    loadSaleRequestTemp = LoadSaleRequestTempSpy();
    finishSaleRequestTemp = FinishSaleRequestTempSpy();
    addPrintRequest = AddPrintRequestSpy();
    localPrintRequest = LocalPrintRequestSpy();
    updateSaleRequestTemp = UpdateSaleRequestTempSpy();
    confirmedCartProducts = ConfirmedCartProductsSpy();
    cartInformations = CartInformationsSpy();
    barcodeScanner = BarcodeScannerSpy();
    commandInformations = CommandInformationsSpy();
    alreadyPaid = AlreadyPaidSpy();
  }

  void initPresenters() {
    menuPresenter = MenuPresenterSpy();
    printedProductsPresenter = PrintedProductsPresenterSpy();
    homePresenter = HomePresenterSpy();
    insertProductPresenter = InsertProductsPresenterSpy();

    sut = GetxCartPresenter(
      loadSaleRequestTemp: loadSaleRequestTemp,
      finishSaleRequestTemp: finishSaleRequestTemp,
      addPrintRequest: addPrintRequest,
      localPrintRequest: localPrintRequest,
      updateSaleRequestTemp: updateSaleRequestTemp,
      confirmedCartProducts: confirmedCartProducts,
      cartInformations: cartInformations,
      barcodeScanner: barcodeScanner,
      commandInformations: commandInformations,
      alreadyPaid: alreadyPaid,
    );
    expansibleGroupFromProductPresenter =
        ExpansibleGroupFromProductPresenterSpy();
  }

  void initEntitys() {
    EnterpriseDataBuilder.enterpriseDataEntity =
        EntityFactory.makeEnterpriseData();
    homePresenter.commandNumberMock =
        faker.randomGenerator.integer(3).toString();
    comments = faker.randomGenerator.string(10);
    tableNumber = faker.randomGenerator.integer(1000, min: 1);

    saleRequestTempEntity =
        EntityFactory.makeSaleRequestTempEntity(tableNumber);
    cartProductEntity = EntityFactory.makeCartProductEntity(
      generateChilds: true,
      maximumProductQuantity: 200,
      minimumProductQuantity: 2,
    );
    cartProductWithOneQuantity = EntityFactory.makeCartProductEntity(
      generateChilds: true,
      maximumProductQuantity: 1,
      minimumProductQuantity: 1,
    );
    commandNumber = faker.randomGenerator.integer(100).toString();

    cartSaleRequestTempProductsEntity = sut.cartProducts
        .map((element) => UpdateSaleRequestTempProductEntity(
            ProductInternalCodeOnErp:
                element.toEntity().Product.InternalCodeOnERP!.toInt(),
            ProductPriceLookUpCode: element.toEntity().ProductPriceLookUpCode,
            Quantity: element.Quantity.toDouble(),
            SaleRequestTempId: saleRequestTempEntity.SaleRequestTempId.toInt(),
            TotalLiquid: element.TotalLiquid.toDouble(),
            Value: element.Value.toDouble(),
            Comments: element.Comments))
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
    );

    cartProductViewModel = CartProductsViewModel.fromEntity(cartProductEntity);

    commentViewModel =
        EntityFactory.makeExpansibleGroupFromProductViewModel(selected: true);
    printRequestEntity = EntityFactory.makePrintRequestEntity();
  }

  void initMockSuccess() {
    loadSaleRequestTemp.mockLoadSaleRequestTemp(saleRequestTempEntity);
    localPrintRequest.mockGetMergedPrinted(null);
    cartInformations.mockSaveCart([cartProductViewModel]);
    cartInformations.mockGetCart([cartProductViewModel]);
    barcodeScanner.mockBarcodeScanner(commandNumber);
    alreadyPaid.mockVerify(false);
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
        product: cartProductEntity,
        menuPresenter: menuPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );

      verify(
        () => cartInformations.updateCartProducts([cartProductViewModel]),
      ).called(1);
    });

    test("Should not add product in cart if cartInformations.update throws",
        () async {
      cartInformations.mockSaveError();

      await sut.addProductInCart(
        product: cartProductEntity,
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
        product: cartProductEntity,
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
        product: cartProductEntity,
        menuPresenter: menuPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );
    });

    test(
        "Should call cartInformations.update when removeProductFromCart succeeds",
        () async {
      await sut.addProductInCart(
        product: cartProductEntity,
        menuPresenter: menuPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );
      await sut.removeProductFromCart(0);

      verify(
        () => cartInformations.updateCartProducts([
          CartProductsViewModel(
            Comments: null,
            Product: cartProductViewModel.Product,
            TotalLiquid: cartProductViewModel.TotalLiquid,
            Quantity: cartProductViewModel.Quantity,
            Value: cartProductViewModel.Value,
            ProductPriceLookUpCode: cartProductViewModel.ProductPriceLookUpCode,
          )
        ]),
      ).called(1);
    });
    test(
        "Should NOT remove product from cart when cartInformations.update throws",
        () async {
      sut.cartProducts.add(cartProductViewModel);

      cartInformations.mockSaveError();
      await sut.removeProductFromCart(0);

      expect(sut.cartProducts, [cartProductViewModel]);
    });

    test("Should emit correct events on removeProductFromCart success",
        () async {
      expectLater(sut.mainErrorStream, emits(null));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      sut.cartProducts.add(cartProductViewModel);

      await sut.removeProductFromCart(0);
    });
    test("Should emit correct events on removeProductFromCart throws",
        () async {
      cartInformations.mockSaveError();
      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      sut.cartProducts.add(cartProductViewModel);

      await sut.removeProductFromCart(0);
    });
    test(
        "Should not remove product from cart when quantity is 1 and cartInformations.update throws",
        () async {
      sut.cartProducts.add(cartProductViewModel);

      cartInformations.mockSaveError();
      await sut.reduceCartProductQuantity(0);

      expect(sut.cartProducts.length, 1);
    });
    test(
        "Should not reduce productQuantity when cartInformations.update throws",
        () async {
      sut.cartProducts.add(cartProductViewModel);

      cartInformations.mockSaveError();
      await sut.reduceCartProductQuantity(0);

      expect(
        sut.cartProducts.first.Quantity.toDouble(),
        cartProductEntity.Quantity,
      );
    });

    test("Should reduce productQuantity when cartInformations.update succeeds",
        () async {
      sut.cartProducts.add(cartProductViewModel);

      await sut.reduceCartProductQuantity(0);

      expect(
        sut.cartProducts.first.Quantity.toDouble(),
        cartProductEntity.Quantity - 1,
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
      sut.cartProducts.add(cartProductViewModel);

      cartInformations.mockSaveError();
      await sut.addCartProductQuantity(0);

      expect(
        sut.cartProducts.first.Quantity.toDouble(),
        cartProductEntity.Quantity,
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
      sut.cartProducts.add(cartProductViewModel);

      await sut.addCartProductQuantity(0);

      expect(
        sut.cartProducts.first.Quantity.toDouble(),
        cartProductEntity.Quantity + 1,
      );
    });
    test("Should emit correct values on addCartProductQuantity succeeds",
        () async {
      expectLater(sut.mainErrorStream, emits(null));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      sut.cartProducts.add(cartProductViewModel);
      await sut.addCartProductQuantity(0);
    });
    test("Should emit correct values on addCartProductQuantity throws",
        () async {
      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      cartInformations.mockSaveError();
      sut.cartProducts.add(cartProductViewModel);
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
        commandNumber: homePresenter.commandNumberMock,
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

      expect(sut.cartProducts, [cartProductViewModel]);
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
      sut.cartProducts.add(cartProductViewModel);

      final newComment = faker.randomGenerator.string(10);
      await sut.updateCommentOfProductCart(
        index: 0,
        newComment: newComment,
      );

      final updatedProduct = [
        CartProductsViewModel(
          Product: cartProductViewModel.Product,
          Comments: newComment,
          TotalLiquid: cartProductViewModel.TotalLiquid,
          Quantity: cartProductViewModel.Quantity,
          Value: cartProductViewModel.Value,
          ProductPriceLookUpCode: cartProductViewModel.ProductPriceLookUpCode,
        )
      ];

      verify(() => cartInformations.updateCartProducts(updatedProduct))
          .called(1);
      expect(sut.cartProducts, updatedProduct);
    });
    test("Should not update comment on cartInformations.update throws",
        () async {
      cartInformations.mockSaveError();
      sut.cartProducts.add(cartProductViewModel);

      await sut.updateCommentOfProductCart(
        index: 0,
        newComment: comments,
      );

      expect(sut.cartProducts, [cartProductViewModel]);
    });
    test("Should emit correct events on updateCartProductComment success",
        () async {
      expectLater(sut.mainErrorStream, emits(null));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      sut.cartProducts.add(cartProductViewModel);
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

      sut.cartProducts.add(cartProductViewModel);
      await sut.updateCommentOfProductCart(
        index: 0,
        newComment: comments,
      );
    });
  });

  group("LoadSaleRequestTemp", () {
    test("Should update SaleRequestTemp correctly on LoadSaleRequestTemp",
        () async {
      await sut.loadSaleRequest(homePresenter.commandNumberMock!);

      expect(sut.saleRequestTemp,
          SaleRequestTempViewModel.fromEntity(saleRequestTempEntity));
    });

    test("Should emits correct events on LoadSaleRequestTemp throws", () async {
      loadSaleRequestTemp.mockError(DomainError.unexpected);

      final error = sut.loadSaleRequest(homePresenter.commandNumberMock!);

      expect(error, throwsA(DomainError.unexpected));
    });

    test(
        "Should emits correct events on ticketIsNotPermitted when LoadSaleRequestTemp",
        () async {
      loadSaleRequestTemp.mockError(DomainError.commandNotAvailable);

      final error = sut.loadSaleRequest(homePresenter.commandNumberMock!);

      expect(error, throwsA(DomainError.commandNotAvailable));
    });

    test("Should call LoadSaleRequestTemp with correct values", () async {
      await sut.loadSaleRequest(homePresenter.commandNumberMock!);

      verify(() => loadSaleRequestTemp.load(
          url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
          enterpriseId:
              EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId!,
          commandNumber: homePresenter.commandNumberMock!)).called(1);
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
      finishSaleRequestTemp.mockFinishSaleRequestTempError();

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
        product: cartProductEntity,
        menuPresenter: menuPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );

      expect(sut.cartProducts, [cartProductViewModel]);
    });
    test("Should remove correct product from cart", () async {
      expect(sut.cartProducts, []);
      final cartProduct1 = EntityFactory.makeCartProductEntity(
        maximumProductQuantity: 100, //tanto faz pra esse teste
        minimumProductQuantity: 1, //tanto faz pra esse teste
      );

      await sut.addProductInCart(
        product: cartProductEntity,
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
        cartProductViewModel, //0
        CartProductsViewModel.fromEntity(cartProduct1), //1
      ]);

      await sut.removeProductFromCart(0);
      expect(
          sut.cartProducts, [CartProductsViewModel.fromEntity(cartProduct1)]);

      await sut.removeProductFromCart(0);
      expect(sut.cartProducts, []);
    });

    test("Should update comment correctly", () async {
      sut.cartProducts.add(cartProductViewModel);
      final newComment = faker.randomGenerator.string(20);

      await sut.updateCommentOfProductCart(index: 0, newComment: newComment);

      final cartProductWithNewComment = CartProductsViewModel(
        Comments: newComment,
        Product: cartProductViewModel.Product,
        TotalLiquid: cartProductViewModel.TotalLiquid,
        Quantity: cartProductViewModel.Quantity,
        Value: cartProductViewModel.Value,
        ProductPriceLookUpCode: cartProductViewModel.ProductPriceLookUpCode,
      );

      expect(sut.cartProducts, [cartProductWithNewComment]);
    });
    test("Should NOT update comment when new comment is equal", () async {
      sut.cartProducts.add(cartProductViewModel);

      await sut.updateCommentOfProductCart(
        index: 0,
        newComment: cartProductViewModel.Comments,
      );

      verifyNever(
          () => cartInformations.updateCartProducts([cartProductViewModel]));
    });
    test("Should update comment with null value if comment is empty", () async {
      sut.cartProducts.add(cartProductViewModel);

      await sut.updateCommentOfProductCart(
        index: 0,
        newComment: "",
      );

      verify(() => cartInformations.updateCartProducts(
            [
              CartProductsViewModel(
                Product: cartProductViewModel.Product,
                Comments: null,
                TotalLiquid: cartProductViewModel.TotalLiquid,
                Quantity: cartProductViewModel.Quantity,
                Value: cartProductViewModel.Value,
                ProductPriceLookUpCode:
                    cartProductViewModel.ProductPriceLookUpCode,
              ),
            ],
          )).called(1);
    });

    test("Should reduce quantity correctly", () async {
      await sut.addProductInCart(
        product: cartProductEntity,
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
          (cartProductEntity.Quantity - 1).toString());

      await sut.reduceCartProductQuantity(1);
      expect(sut.cartProducts.length, 1);
    });

    test("Should update totalLiquid correctly when reduce quantity", () async {
      await sut.addProductInCart(
        product: cartProductEntity,
        menuPresenter: menuPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );
      expect(sut.cartProducts[0].TotalLiquid,
          cartProductEntity.TotalLiquid.toString());

      await sut.reduceCartProductQuantity(0);
      expect(
        sut.cartProducts[0].TotalLiquid,
        (cartProductEntity.Value * (cartProductEntity.Quantity - 1)).toString(),
      );
    });

    test("Should add quantity correctly", () async {
      await sut.addProductInCart(
        product: cartProductEntity,
        menuPresenter: menuPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );

      await sut.addCartProductQuantity(0);

      expect(sut.cartProducts[0].Quantity,
          (cartProductEntity.Quantity + 1).toString());
    });

    test("Should update totalLiquid correctly when add quantity", () async {
      await sut.addProductInCart(
        product: cartProductEntity,
        menuPresenter: menuPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );
      expect(sut.cartProducts[0].TotalLiquid,
          cartProductEntity.TotalLiquid.toString());

      await sut.addCartProductQuantity(0);
      expect(
        sut.cartProducts[0].TotalLiquid,
        (cartProductEntity.Value * (cartProductEntity.Quantity + 1)).toString(),
      );
    });

    test("Should clear indexOfSelectedProduct when add a product", () async {
      await sut.addProductInCart(
        product: cartProductEntity,
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
        product: cartProductEntity,
        menuPresenter: menuPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );

      expansibleGroupFromProductPresenter
          .mockGetConcatenateSelectedComments(faker.randomGenerator.string(10));
      await sut.addProductInCart(
        product: cartProductEntity,
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
        product: cartProductEntity,
        menuPresenter: menuPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );

      final productWithNewComment = CartProductEntity(
        Product: cartProductEntity.Product,
        Comments: cartProductEntity.Comments,
        TotalLiquid: cartProductEntity.TotalLiquid,
        Quantity: cartProductEntity.Quantity,
        Value: 726871278512785348193219.0,
        ProductPriceLookUpCode: cartProductEntity.ProductPriceLookUpCode,
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
        product: cartProductEntity,
        menuPresenter: menuPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );

      expect(sut.cartProducts, [
        CartProductsViewModel(
          Comments:
              "${commentViewModel.GroupName}\n${commentViewModel.GroupName}",
          Product: cartProductViewModel.Product,
          TotalLiquid: cartProductEntity.TotalLiquid.toString(),
          Quantity: cartProductEntity.Quantity.toString(),
          Value: cartProductEntity.Value.toString(),
          ProductPriceLookUpCode: cartProductEntity.ProductPriceLookUpCode,
        ),
      ]);
    });

    test("Should clear cartProducts on call clearCartAndConfirmedCombox",
        () async {
      sut.cartProducts.add(cartProductViewModel);
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

  group("Save cart products in saleRequesTemp", () {
    test("Should call correct functions on save products in SaleRequestTemp",
        () async {
      cartProductViewModel.Product.childsComposition = null;

      sut.cartProducts.add(cartProductViewModel);
      confirmedCartProducts.mockIsConfirmed(false);

      await sut.saveProducts(
        insertProductPresenter: insertProductPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
        printedProductsPresenter: printedProductsPresenter,
        tableNumber: tableNumber,
        homePresenter: homePresenter,
        commandNumber: homePresenter.commandNumberMock,
      );

      verify(() => barcodeScanner.read()).called(1);

      verify(
        () => loadSaleRequestTemp.load(
          url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
          enterpriseId:
              EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId!,
          commandNumber: commandNumber,
        ),
      ).called(2);

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
        TotalLiquid: cartProductViewModel.TotalLiquid.toDouble(),
        Products: [
          UpdateSaleRequestTempProductEntity(
            ProductInternalCodeOnErp:
                cartProductViewModel.Product.InternalCodeOnERP!.toInt(),
            ProductPriceLookUpCode: cartProductViewModel.ProductPriceLookUpCode,
            Quantity: cartProductViewModel.Quantity.toDouble(),
            SaleRequestTempId: updateSaleRequestTempEntity.SaleRequestTempId,
            TotalLiquid: cartProductViewModel.TotalLiquid.toDouble(),
            Value: cartProductViewModel.Value.toDouble(),
            Comments: cartProductViewModel.Comments,
          )
        ],
      );

      verify(() => updateSaleRequestTemp.update(
          url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
          entity: teste)).called(1);

      verify(() => finishSaleRequestTemp.finish(
            saleRequestTempEntity: saleRequestTempEntity,
            url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
          )).called(1);
      verify(() => printedProductsPresenter.loadPrinted(homePresenter))
          .called(1);
    });
    test(
        "Should convert correctly combox products to UpdateSaleRequestTempProductEntity on saveProducts",
        () async {
      for (var child in cartProductViewModel.Product.childsComposition!) {
        child.indexOfSelectedChild = 0;
      }
      sut.cartProducts.add(cartProductViewModel);

      final products =
          sut.convertProductsCompositionToUpdateSaleRequestTempProductEntity(
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
        commandNumber: homePresenter.commandNumberMock,
      );

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
        TotalLiquid: products.fold(0.0,
            (previousValue, element) => element.TotalLiquid + previousValue),
        Products: [...products],
      );

      verify(() => updateSaleRequestTemp.update(
            url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
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
        commandNumber: homePresenter.commandNumberMock,
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
    //     commandNumber: homePresenter.commandNumberMock,
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
    //     commandNumber: homePresenter.commandNumberMock,
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
          url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
          enterpriseId:
              EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId!,
          commandNumber: commandNumber,
        ),
      ).called(1);

      verifyNever(() => confirmedCartProducts.isConfirmed());
      verifyNever(() => confirmedCartProducts.updateValue(true));
      verifyNever(() => confirmedCartProducts.updateValue(false));

      verifyNever(() => updateSaleRequestTemp.update(
            url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
            entity: updateSaleRequestTempEntity,
          ));

      verifyNever(() => finishSaleRequestTemp.finish(
            saleRequestTempEntity: saleRequestTempEntity,
            url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
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
          url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
          enterpriseId:
              EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId!,
          commandNumber: commandNumber,
        ),
      ).called(1);

      verifyNever(() => confirmedCartProducts.isConfirmed());
      verifyNever(() => confirmedCartProducts.updateValue(true));
      verifyNever(() => confirmedCartProducts.updateValue(false));

      verifyNever(() => updateSaleRequestTemp.update(
            url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
            entity: updateSaleRequestTempEntity,
          ));

      verifyNever(() => finishSaleRequestTemp.finish(
            saleRequestTempEntity: saleRequestTempEntity,
            url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
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
          url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
          enterpriseId:
              EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId!,
          commandNumber: commandNumber,
        ),
      ).called(1);

      verify(() => updateSaleRequestTemp.update(
            url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
            entity: updateSaleRequestTempEntity,
          )).called(1);

      verify(() => confirmedCartProducts.isConfirmed()).called(1);
      verifyNever(() => confirmedCartProducts.updateValue(true));
      verifyNever(() => confirmedCartProducts.updateValue(false));

      verifyNever(() => finishSaleRequestTemp.finish(
            saleRequestTempEntity: saleRequestTempEntity,
            url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
          ));
    });
    test("Should emit correct values finishSaleRequestTemp throws", () async {
      finishSaleRequestTemp.mockFinishSaleRequestTempError();

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
      finishSaleRequestTemp.mockFinishSaleRequestTempError();

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
          url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
          enterpriseId:
              EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId!,
          commandNumber: commandNumber,
        ),
      ).called(2);

      verify(() => updateSaleRequestTemp.update(
            url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
            entity: updateSaleRequestTempEntity,
          )).called(1);

      verify(() => finishSaleRequestTemp.finish(
            saleRequestTempEntity: saleRequestTempEntity,
            url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
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
      finishSaleRequestTemp.mockFinishSaleRequestTempError();

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
            url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
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
            url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
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
            url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
            entity: updateSaleRequestTempEntity,
          )).called(1);
    });
    test("Should clear cartProducts on saveProducts succeeds", () async {
      sut.addProductInCart(
        product: cartProductEntity,
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

    test("Should save DeliveryControl with correct value", () async {
      sut.cartProducts.add(cartProductViewModel);

      await sut.saveProducts(
        insertProductPresenter: insertProductPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
        printedProductsPresenter: printedProductsPresenter,
        tableNumber: null,
        homePresenter: homePresenter,
      );

      verify(() => finishSaleRequestTemp.finish(
            saleRequestTempEntity: SaleRequestTempEntity(
              Peoples: updateSaleRequestTempEntity.Peoples,
              DeliveryControl: null,
              Products: saleRequestTempEntity.Products,
              SaleRequestTempId: saleRequestTempEntity.SaleRequestTempId,
              PersonalizedCode: saleRequestTempEntity.PersonalizedCode,
              EnterpriseId: saleRequestTempEntity.EnterpriseId,
              TotalLiquid: saleRequestTempEntity.TotalLiquid,
              Comments: saleRequestTempEntity.Comments,
              SellerCode: saleRequestTempEntity.SellerCode,
              CustomerCode: saleRequestTempEntity.CustomerCode,
              CovenantCode: saleRequestTempEntity.CovenantCode,
            ),
            url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
          )).called(1);
    });
    test(
        "Should save DeliveryControl with correct tableNumber when is differente than 0",
        () async {
      sut.cartProducts.add(cartProductViewModel);
      confirmedCartProducts.mockIsConfirmed(false);

      await sut.saveProducts(
        insertProductPresenter: insertProductPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
        printedProductsPresenter: printedProductsPresenter,
        tableNumber: tableNumber,
        homePresenter: homePresenter,
      );

      verify(() => finishSaleRequestTemp.finish(
            saleRequestTempEntity: SaleRequestTempEntity(
              Peoples: updateSaleRequestTempEntity.Peoples,
              SellerCode: updateSaleRequestTempEntity.SellerCode,
              DeliveryControl: tableNumber,
              Products: saleRequestTempEntity.Products,
              SaleRequestTempId: saleRequestTempEntity.SaleRequestTempId,
              PersonalizedCode: saleRequestTempEntity.PersonalizedCode,
              EnterpriseId: saleRequestTempEntity.EnterpriseId,
              TotalLiquid: saleRequestTempEntity.TotalLiquid,
              Comments: saleRequestTempEntity.Comments,
              CustomerCode: saleRequestTempEntity.CustomerCode,
              CovenantCode: saleRequestTempEntity.CovenantCode,
            ),
            url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
          )).called(1);
    });
    test(
        "Should not call barcodeScanner.read if homePresenter.isFixedCommandNumber",
        () async {
      homePresenter.isFixedCommandNumberMock = true;
      expect(homePresenter.isFixedCommandNumber, true);

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
      homePresenter.isFixedCommandNumberMock = true;

      final fixedCommandNumber = faker.randomGenerator.integer(999).toString();
      homePresenter.commandNumberMock = fixedCommandNumber;
      expect(homePresenter.commandNumber, fixedCommandNumber);

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
          url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
          enterpriseId:
              EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId!,
          commandNumber: commandNumber,
        ),
      );
    });

    test("Should call alreadyPaid on saveProducts", () async {
      await sut.saveProducts(
        insertProductPresenter: insertProductPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
        printedProductsPresenter: printedProductsPresenter,
        tableNumber: tableNumber,
        homePresenter: homePresenter,
        commandNumber: homePresenter.commandNumberMock,
      );

      verify(() => alreadyPaid.verify()).called(1);
    });

    test("Should emit correct values on command already paid", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
        sut.mainErrorStream,
        emitsInOrder([null, UIError.commandAlreadyPaid]),
      );

      alreadyPaid.mockVerify(true);

      await sut.saveProducts(
        insertProductPresenter: insertProductPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
        printedProductsPresenter: printedProductsPresenter,
        tableNumber: tableNumber,
        homePresenter: homePresenter,
        commandNumber: homePresenter.commandNumberMock,
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

      homePresenter.isFixedCommandNumberMock = false;

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
      homePresenter.isFixedCommandNumberMock = false;
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

      verify(() => homePresenter
          .updateCommandNumber(newCommandNumber.padLeft(3, "0"))).called(1);
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
      cartProductViewModel.Product.childsComposition =
          productsSelectedsInCombox;
      final firstChild = cartProductViewModel.Product.childsComposition![0];
      final secondChild = cartProductViewModel.Product.childsComposition![1];

      await sut.addProductInCart(
        product: cartProductViewModel.toEntity(),
        menuPresenter: menuPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );

      // sut.confirmedCombox.add(comboxWithSelectedProducts);
      //adiciono esse combo pra conseguir testar

      final fakeSaleRequestTempId = faker.randomGenerator.integer(10);
      //deixo o id randômico pra ter certeza que vai funcionar

      final entity =
          sut.convertProductsCompositionToUpdateSaleRequestTempProductEntity(
        saleRequestTempId: fakeSaleRequestTempId,
        insertProductPresenter: insertProductPresenter,
      ); //converto o combo pra uma lista de produtos da forma que usa pra adicionar na comanda

      expect(entity, [
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
        ),
      ]);
    });
  });
}
