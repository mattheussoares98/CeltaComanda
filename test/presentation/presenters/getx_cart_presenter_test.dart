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

  late LoadSaleRequestTempSpy loadSaleRequestTemp;
  late UpdateProductQuantitySpy updateProductQuantity;
  late UpdateProductCommentSpy updateProductComment;
  late FinishSaleRequestTempSpy finishSaleRequestTemp;
  late TicketIsPermittedSpy ticketIsPermitted;
  late AddPrintRequestSpy addPrintRequest;
  late LocalPrintRequestSpy localPrintRequest;
  late UpdateSaleRequestTempSpy updateSaleRequestTemp;
  late ConfirmedCartProductsSpy confirmedCartProducts;
  late CartInformationsSpy cartInformations;
  late BarcodeScannerSpy barcodeScanner;

  late SaleRequestTempEntity saleRequestTempEntity;
  late int saleRequestProductTempId;
  late String comments;
  late PrintRequestEntity printRequestEntity;
  late CartProductEntity cartProductEntity;
  late String commandNumber;
  late UpdateSaleRequestTempEntity updateSaleRequestTempEntity;
  late List<UpdateSaleRequestTempProductEntity>
      updateSaleRequestTempProductsEntity;
  late CartProductsViewModel cartProductViewModel;
  late CartProductEntity cartProductWithOneQuantity;
  late ProductsViewModel fatherOfCombox;
  late ProductCompositionViewModel selectedChildWithOneQuantity;
  late ProductCompositionViewModel selectedChildWithTwoQuantities;
  late ProductCompositionViewModel notSelectedChild;
  late ConfirmedComboxViewModel confirmedComboxWithOneQuantity;
  late ConfirmedComboxViewModel confirmedComboxWithtwoQuantities;
  late String? newComment;

  void initUsecases() {
    loadSaleRequestTemp = LoadSaleRequestTempSpy();
    updateProductQuantity = UpdateProductQuantitySpy();
    updateProductComment = UpdateProductCommentSpy();
    finishSaleRequestTemp = FinishSaleRequestTempSpy();
    ticketIsPermitted = TicketIsPermittedSpy();
    addPrintRequest = AddPrintRequestSpy();
    localPrintRequest = LocalPrintRequestSpy();
    updateSaleRequestTemp = UpdateSaleRequestTempSpy();
    confirmedCartProducts = ConfirmedCartProductsSpy();
    cartInformations = CartInformationsSpy();
    barcodeScanner = BarcodeScannerSpy();
  }

  void initPresenters() {
    menuPresenter = MenuPresenterSpy();
    printedProductsPresenter = PrintedProductsPresenterSpy();
    homePresenter = HomePresenterSpy();

    sut = GetxCartPresenter(
      loadSaleRequestTemp: loadSaleRequestTemp,
      updateProductQuantity: updateProductQuantity,
      updateProductComment: updateProductComment,
      finishSaleRequestTemp: finishSaleRequestTemp,
      ticketIsPermitted: ticketIsPermitted,
      addPrintRequest: addPrintRequest,
      localPrintRequest: localPrintRequest,
      updateSaleRequestTemp: updateSaleRequestTemp,
      confirmedCartProducts: confirmedCartProducts,
      cartInformations: cartInformations,
      barcodeScanner: barcodeScanner,
    );
  }

  void initEntitys() {
    EnterpriseDataBuilder.enterpriseDataEntity =
        EntityFactory.makeEnterpriseData();
    saleRequestProductTempId = faker.randomGenerator.integer(3);
    homePresenter.commandNumberMock =
        faker.randomGenerator.integer(3).toString();
    comments = faker.randomGenerator.string(10);
    saleRequestTempEntity = EntityFactory.makeSaleRequestTempEntity();
    printRequestEntity = EntityFactory.makePrintRequestEntity();
    cartProductEntity = EntityFactory.makeCartProductEntity(
      maximumProductQuantity: 200,
      minimumProductQuantity: 2,
    );
    cartProductWithOneQuantity = EntityFactory.makeCartProductEntity(
      maximumProductQuantity: 1,
      minimumProductQuantity: 1,
    );
    commandNumber = faker.randomGenerator.integer(100).toString();

    updateSaleRequestTempProductsEntity = sut.cartProducts
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
    updateSaleRequestTempEntity = UpdateSaleRequestTempEntity(
      DeliveryControl: saleRequestTempEntity.DeliveryControl.toInt(),
      EnterpriseId: saleRequestTempEntity.EnterpriseId.toInt(),
      PersonalizedCode: saleRequestTempEntity.PersonalizedCode,
      SaleRequestTempId: saleRequestTempEntity.SaleRequestTempId.toInt(),
      TotalLiquid: updateSaleRequestTempProductsEntity.fold(
          0.0, (previousValue, element) => element.TotalLiquid + previousValue),
      Products: updateSaleRequestTempProductsEntity,
    );

    cartProductViewModel = CartProductsViewModel.fromEntity(cartProductEntity);

    fatherOfCombox = EntityFactory.makeProductViewModel();
    selectedChildWithOneQuantity =
        EntityFactory.makeProductCompositionViewModel(
      quantity: 1,
      salePrice: 10,
      offerPrice: 10,
      incrementValue: 0,
      isOptionalItem: false,
      indexOfSelectedChild: 0,
    );
    selectedChildWithTwoQuantities =
        EntityFactory.makeProductCompositionViewModel(
      quantity: 2,
      salePrice: 10,
      offerPrice: 10,
      incrementValue: 0,
      isOptionalItem: false,
      indexOfSelectedChild: 0,
    );

    notSelectedChild = EntityFactory.makeProductCompositionViewModel(
      quantity: 1,
      salePrice: 10,
      offerPrice: 10,
      incrementValue: 0,
      isOptionalItem: false,
      indexOfSelectedChild: null,
    );

    confirmedComboxWithOneQuantity = EntityFactory.makeConfirmedComboxViewModel(
      products: [selectedChildWithOneQuantity],
      father: fatherOfCombox,
      totalPrice: 10,
      quantity: 1,
    );
    confirmedComboxWithtwoQuantities =
        EntityFactory.makeConfirmedComboxViewModel(
      products: [selectedChildWithTwoQuantities],
      father: fatherOfCombox,
      totalPrice: 20,
      quantity: 2,
    );
    newComment = faker.randomGenerator.string(10);
  }

  void initMockSuccess() {
    loadSaleRequestTemp.mockLoadSaleRequestTemp(saleRequestTempEntity);
    localPrintRequest.mockGetMergedPrinted(null);
    cartInformations.mockSaveCart([cartProductViewModel]);
    cartInformations.mockGetCart([cartProductViewModel]);
    cartInformations
        .mockUpdateConfirmedCombox([confirmedComboxWithOneQuantity]);
    cartInformations.mockGetConfirmedsCombox([confirmedComboxWithOneQuantity]);
    barcodeScanner.mockBarcodeScanner(commandNumber);
  }

  setUp(() {
    initUsecases();
    initPresenters();
    initEntitys();
    initMockSuccess();
  });

  setUpAll(() {
    registerFallbackValue(EntityFactory.makeSaleRequestTempEntity());
    registerFallbackValue(EntityFactory.makePrintRequestEntity());
    registerFallbackValue(EntityFactory.makeUpdateSaleRequestTempEntity());
    registerFallbackValue(EntityFactory.makeProductViewModel());
    registerFallbackValue(PrintedProductsPresenterSpy());
    registerFallbackValue(CartPresenterSpy());
    registerFallbackValue(MenuPresenterSpy());
    registerFallbackValue(UpdateSaleRequestTempEntity);
  });

  group("CartInformations", () {
    test("Should call updateCartInformations on addProductInCart", () async {
      await sut.addProductInCart(
        product: cartProductEntity,
        menuPresenter: menuPresenter,
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
      );

      expect(sut.cartProducts, []);
    });
    test("Should emit correct events on addProductInCart success", () async {
      expectLater(sut.mainErrorStream, emits(null));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.addProductInCart(
        product: cartProductEntity,
        menuPresenter: menuPresenter,
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
      );
    });

    test(
        "Should call cartInformations.update when removeProductFromCart succeeds",
        () async {
      await sut.addProductInCart(
        product: cartProductEntity,
        menuPresenter: menuPresenter,
      );

      verify(
        () => cartInformations.updateCartProducts([cartProductViewModel]),
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

      await sut.addCartProductQuantity(0);
    });
    test("Should emit correct values on addCartProductQuantity throws",
        () async {
      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      cartInformations.mockSaveError();
      await sut.addCartProductQuantity(0);
    });

    test("Should call cartInformations.clear when saveProducts succeeds",
        () async {
      await sut.saveProducts(printedProductsPresenter);

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
  group("AddProductQuantity group", () {
    test("Should call AddProductQuantity with correct values", () async {
      await sut.addProductQuantity(
        url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
        saleRequestProductTempId: saleRequestProductTempId,
        commandNumber: homePresenter.commandNumberMock!,
      );

      verify(
        () => updateProductQuantity.add(
          url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
          saleRequestProductTempId: saleRequestProductTempId,
        ),
      ).called(1);
    });

    test("Should emits correct events on error to AddProductQuantity",
        () async {
      updateProductQuantity.mockAddProductQuantityError();

      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.addProductQuantity(
        url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
        saleRequestProductTempId: saleRequestProductTempId,
        commandNumber: homePresenter.commandNumberMock!,
      );
    });

    test("Should emits correct events on AddtractProductQuantity", () async {
      expectLater(sut.mainErrorStream, emits(null));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.addProductQuantity(
          url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
          saleRequestProductTempId: saleRequestProductTempId,
          commandNumber: homePresenter.commandNumberMock!);
    });
  });
  group("SubtractProductQuantity group", () {
    test("Should call SubtractProductQuantity with correct values", () async {
      await sut.subtractProductQuantity(
          url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
          saleRequestProductTempId: saleRequestProductTempId,
          productQuantity: 10,
          commandNumber: homePresenter.commandNumberMock!);

      verify(
        () => updateProductQuantity.subtract(
          url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
          saleRequestProductTempId: saleRequestProductTempId,
        ),
      );
    });

    test("Should emits correct events on error to SubtractProductQuantity",
        () async {
      updateProductQuantity.mockSubtractProductQuantityError();

      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.subtractProductQuantity(
          url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
          saleRequestProductTempId: saleRequestProductTempId,
          productQuantity: 10,
          commandNumber: homePresenter.commandNumberMock!);
    });

    test("Should emits correct events on SubtractProductQuantity", () async {
      expectLater(sut.mainErrorStream, emits(null));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.subtractProductQuantity(
          url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
          saleRequestProductTempId: saleRequestProductTempId,
          productQuantity: 10,
          commandNumber: homePresenter.commandNumberMock!);
    });

    test("Should call delete product if productQuantity is less than 1",
        () async {
      await sut.subtractProductQuantity(
          url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
          saleRequestProductTempId: saleRequestProductTempId,
          productQuantity: 1,
          commandNumber: homePresenter.commandNumberMock!);

      verify(
        () => updateProductQuantity.delete(
          url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
          saleRequestProductTempId: saleRequestProductTempId,
        ),
      ).called(1);
    });

    test(
        "Should call subtract product quantity if productQuantity is more than 1",
        () async {
      await sut.subtractProductQuantity(
          url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
          saleRequestProductTempId: saleRequestProductTempId,
          productQuantity: 2,
          commandNumber: homePresenter.commandNumberMock!);

      verify(
        () => updateProductQuantity.subtract(
          url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
          saleRequestProductTempId: saleRequestProductTempId,
        ),
      ).called(1);
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

  group("UpdateProductComment", () {
    test("Should call UpdateComment with correct values", () async {
      await sut.updateComment(
        comments: comments,
        saleRequestProductTempId: saleRequestProductTempId,
        menuPresenter: menuPresenter,
        printedProductsPresenter: printedProductsPresenter,
        cartPresenter: sut,
        homePresenter: homePresenter,
      );

      verify(() => updateProductComment.update(
            url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
            saleRequestProductTempId: saleRequestProductTempId,
            comments: comments,
          ));
    });

    test("Should emit correct events on UpdateComment success", () async {
      expectLater(sut.mainErrorStream, emits(null));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.updateComment(
        comments: comments,
        saleRequestProductTempId: saleRequestProductTempId,
        menuPresenter: menuPresenter,
        printedProductsPresenter: printedProductsPresenter,
        cartPresenter: sut,
        homePresenter: homePresenter,
      );
    });

    test("Should emit correct events on UpdateComment throws", () async {
      updateProductComment
          .mockUpdateProductCommentError(DomainError.unexpected);

      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.updateComment(
        comments: comments,
        saleRequestProductTempId: saleRequestProductTempId,
        menuPresenter: menuPresenter,
        printedProductsPresenter: printedProductsPresenter,
        cartPresenter: sut,
        homePresenter: homePresenter,
      );
    });

    test("Should emit correct events on UpdateComment cant add comment",
        () async {
      updateProductComment
          .mockUpdateProductCommentError(DomainError.addComment);

      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.addComment]));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.updateComment(
        comments: comments,
        saleRequestProductTempId: saleRequestProductTempId,
        menuPresenter: menuPresenter,
        printedProductsPresenter: printedProductsPresenter,
        cartPresenter: sut,
        homePresenter: homePresenter,
      );
    });

    test("Should clear selectedProductIndex on success to UpdateComment",
        () async {
      sut.updateIndexOfSelectedCartProduct(1);

      expect(sut.indexOfSelectedProduct, 1);
      await sut.updateComment(
        comments: comments,
        saleRequestProductTempId: saleRequestProductTempId,
        menuPresenter: menuPresenter,
        printedProductsPresenter: printedProductsPresenter,
        cartPresenter: sut,
        homePresenter: homePresenter,
      );
      expect(sut.indexOfSelectedProduct, null);
    });

    test("Should call expansibleGroups.load when UpdateComment", () async {
      await sut.updateComment(
        comments: comments,
        saleRequestProductTempId: saleRequestProductTempId,
        menuPresenter: menuPresenter,
        printedProductsPresenter: printedProductsPresenter,
        cartPresenter: sut,
        homePresenter: homePresenter,
      );

      verify(() => homePresenter
          .updateCommandNumber(homePresenter.commandNumberMock!)).called(1);
      verify(() => printedProductsPresenter.clear()).called(1);
      verify(() => menuPresenter.clear()).called(1);
      verify(() => ticketIsPermitted.verify(
          url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
          commandNumber: homePresenter.commandNumberMock!)).called(1);
      verify(() => loadSaleRequestTemp.load(
            url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
            enterpriseId:
                EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId!,
            commandNumber: homePresenter.commandNumberMock!,
          )).called(1);
      expect(sut.indexOfSelectedProduct, null);
      expect(
        sut.saleRequestTemp,
        SaleRequestTempViewModel.fromEntity(saleRequestTempEntity),
      );
    });
  });

  group("FinishSaleRequestTemp", () {
    test("Should call FinishSaleRequestTemp with correct values", () async {
      await sut.finishSaleRequest(
        saleRequestTempEntity: saleRequestTempEntity,
        menuPresenter: menuPresenter,
        printedProductsPresenter: printedProductsPresenter,
        cartPresenter: sut,
        homePresenter: homePresenter,
      );

      verify(
        () => finishSaleRequestTemp.finish(
          saleRequestTempEntity: saleRequestTempEntity,
          url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
        ),
      ).called(1);
    });

    test("Should emit correct events on FinishSaleRequestTemp success",
        () async {
      expectLater(sut.mainErrorStream, emits(null));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.finishSaleRequest(
        saleRequestTempEntity: saleRequestTempEntity,
        menuPresenter: menuPresenter,
        printedProductsPresenter: printedProductsPresenter,
        cartPresenter: sut,
        homePresenter: homePresenter,
      );
    });

    test("Should emit correct events on FinishSaleRequestTemp throws",
        () async {
      finishSaleRequestTemp.mockFinishSaleRequestTempError();
      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.finishSaleRequest(
        saleRequestTempEntity: saleRequestTempEntity,
        menuPresenter: menuPresenter,
        printedProductsPresenter: printedProductsPresenter,
        cartPresenter: sut,
        homePresenter: homePresenter,
      );
    });

    test("Should call MenuPresenter.load on FinishSaleRequest success",
        () async {
      await sut.finishSaleRequest(
        saleRequestTempEntity: saleRequestTempEntity,
        menuPresenter: menuPresenter,
        printedProductsPresenter: printedProductsPresenter,
        cartPresenter: sut,
        homePresenter: homePresenter,
      );

      verify(() => homePresenter
          .updateCommandNumber(homePresenter.commandNumberMock!)).called(1);
      verify(() => printedProductsPresenter.clear()).called(1);
      verify(() => menuPresenter.clear()).called(1);
      verify(() => ticketIsPermitted.verify(
          url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
          commandNumber: homePresenter.commandNumberMock!)).called(1);
      verify(() => loadSaleRequestTemp.load(
            url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
            enterpriseId:
                EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId!,
            commandNumber: homePresenter.commandNumberMock!,
          )).called(1);
      expect(sut.indexOfSelectedProduct, null);
      expect(
        sut.saleRequestTemp,
        SaleRequestTempViewModel.fromEntity(saleRequestTempEntity),
      );
    });
  });

  group("Add PrintRequest", () {
    test("Should call addPrintRequest when finish success", () async {
      await sut.finishSaleRequest(
        saleRequestTempEntity: saleRequestTempEntity,
        menuPresenter: menuPresenter,
        printedProductsPresenter: printedProductsPresenter,
        cartPresenter: sut,
        homePresenter: homePresenter,
      );

      verify(
        () => addPrintRequest.add(printRequestEntity),
      ).called(1);
    });

    test(
        "Should call correct printRequests when finish success and has printRequestEntity in local data",
        () async {
      localPrintRequest.mockGetMergedPrinted(printRequestEntity);

      await sut.finishSaleRequest(
        saleRequestTempEntity: saleRequestTempEntity,
        menuPresenter: menuPresenter,
        printedProductsPresenter: printedProductsPresenter,
        cartPresenter: sut,
        homePresenter: homePresenter,
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
      await sut.finishSaleRequest(
        saleRequestTempEntity: saleRequestTempEntity,
        menuPresenter: menuPresenter,
        printedProductsPresenter: printedProductsPresenter,
        cartPresenter: sut,
        homePresenter: homePresenter,
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

      await sut.finishSaleRequest(
        saleRequestTempEntity: saleRequestTempEntity,
        menuPresenter: menuPresenter,
        printedProductsPresenter: printedProductsPresenter,
        cartPresenter: sut,
        homePresenter: homePresenter,
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

      await sut.finishSaleRequest(
        saleRequestTempEntity: saleRequestTempEntity,
        menuPresenter: menuPresenter,
        printedProductsPresenter: printedProductsPresenter,
        cartPresenter: sut,
        homePresenter: homePresenter,
      );

      verify(
        () => localPrintRequest.add(printRequestEntity),
      ).called(1);
    });

    test(
        "Should call LocalAddPrintRequest when localPrintRequest.GetMergedPrint throws",
        () async {
      localPrintRequest.mockGetMergedPrintedError();

      await sut.finishSaleRequest(
        saleRequestTempEntity: saleRequestTempEntity,
        menuPresenter: menuPresenter,
        printedProductsPresenter: printedProductsPresenter,
        cartPresenter: sut,
        homePresenter: homePresenter,
      );

      verify(
        () => localPrintRequest.add(printRequestEntity),
      ).called(1);
    });
  });

  group("Load commandData", () {
    test("Should emit correct values on success", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.mainErrorStream, emits(null));

      await sut.loadCommandData(
        commandNumber: homePresenter.commandNumberMock!,
        printedProductsPresenter: printedProductsPresenter,
        cartPresenter: sut,
        menuPresenter: menuPresenter,
        homePresenter: homePresenter,
      );
    });

    test(
        "Should emit correct values on loadCommandData throws commandNotAvailable",
        () async {
      ticketIsPermitted.mockError();

      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.mainErrorStream,
          emitsInOrder([null, UIError.commandNotAvailable]));

      await sut.loadCommandData(
        commandNumber: homePresenter.commandNumberMock!,
        printedProductsPresenter: printedProductsPresenter,
        cartPresenter: sut,
        menuPresenter: menuPresenter,
        homePresenter: homePresenter,
      );
    });

    test("Should update commandNumber", () async {
      homePresenter.commandNumberMock = "9999";

      await sut.loadCommandData(
        commandNumber: homePresenter.commandNumberMock!,
        printedProductsPresenter: printedProductsPresenter,
        cartPresenter: sut,
        menuPresenter: menuPresenter,
        homePresenter: homePresenter,
      );

      expect(homePresenter.commandNumberMock, "9999");
    });

    test("Should call clearData on LoadCommandData call", () async {
      await sut.loadCommandData(
        commandNumber: homePresenter.commandNumberMock!,
        printedProductsPresenter: printedProductsPresenter,
        cartPresenter: sut,
        menuPresenter: menuPresenter,
        homePresenter: homePresenter,
      );

      expect(
        sut.saleRequestTemp,
        SaleRequestTempViewModel.fromEntity(saleRequestTempEntity),
      );

      loadSaleRequestTemp.mockError(DomainError.unexpected);

      await sut.loadCommandData(
        commandNumber: homePresenter.commandNumberMock!,
        printedProductsPresenter: printedProductsPresenter,
        cartPresenter: sut,
        menuPresenter: menuPresenter,
        homePresenter: homePresenter,
      );

      expect(sut.saleRequestTemp, null);
      verify(() => printedProductsPresenter.clear()).called(2);
      verify(() => menuPresenter.clear()).called(2);
      //como o sut não é mockado, fiz um teste primeiro com sucesso pra ter
      //certeza que vai colocar dados no expansibleGroups e outro teste com
      //erro, pra ter certeza que vai chamar a função para limpar a lista de
      //grupos expansíveis
    });

    test("Should call ticketIsPermitted only one time", () async {
      await sut.loadCommandData(
        commandNumber: homePresenter.commandNumberMock!,
        printedProductsPresenter: printedProductsPresenter,
        cartPresenter: sut,
        menuPresenter: menuPresenter,
        homePresenter: homePresenter,
      );

      verify(() => ticketIsPermitted.verify(
            url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
            commandNumber: homePresenter.commandNumberMock!,
          )).called(1);
    });

    test("Should call loadGroups, saleRequestTemp and PrintedProducts",
        () async {
      await sut.loadCommandData(
        commandNumber: homePresenter.commandNumberMock!,
        printedProductsPresenter: printedProductsPresenter,
        cartPresenter: sut,
        menuPresenter: menuPresenter,
        homePresenter: homePresenter,
      );

      verify(() => loadSaleRequestTemp.load(
            url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
            enterpriseId:
                EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId!,
            commandNumber: homePresenter.commandNumberMock!,
          )).called(1);
      verify(() => menuPresenter
          .getGroupsAndProducts(homePresenter.commandNumberMock!)).called(1);
      verify(() => printedProductsPresenter
          .loadPrinted(homePresenter.commandNumberMock!)).called(1);
    });

    test(
        "Should update commandNumber with null value on error to LoadCommandData",
        () async {
      ticketIsPermitted.mockError();

      await sut.loadCommandData(
        commandNumber: homePresenter.commandNumberMock!,
        printedProductsPresenter: printedProductsPresenter,
        cartPresenter: sut,
        menuPresenter: menuPresenter,
        homePresenter: homePresenter,
      );

      verify(() => homePresenter.updateCommandNumber(null)).called(1);
    });
  });

  group("Cart products", () {
    test("Should add correctly CartProduct", () async {
      expect(sut.cartProducts, []);

      await sut.addProductInCart(
        product: cartProductEntity,
        menuPresenter: menuPresenter,
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
      );
      await sut.addProductInCart(
        product: cartProduct1,
        menuPresenter: menuPresenter,
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

      expect(sut.cartProducts, [
        CartProductsViewModel(
          Comments: newComment,
          Product: ProductsViewModel.fromEntity(cartProductEntity.Product),
          TotalLiquid: cartProductEntity.TotalLiquid.toString(),
          Quantity: cartProductEntity.Quantity.toString(),
          Value: cartProductEntity.Value.toString(),
          ProductPriceLookUpCode: cartProductEntity.ProductPriceLookUpCode,
        )
      ]);
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
      );
      await sut.addProductInCart(
        product: cartProductWithOneQuantity,
        menuPresenter: menuPresenter,
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
      );

      await sut.addCartProductQuantity(0);

      expect(sut.cartProducts[0].Quantity,
          (cartProductEntity.Quantity + 1).toString());
    });

    test("Should update totalLiquid correctly when add quantity", () async {
      await sut.addProductInCart(
        product: cartProductEntity,
        menuPresenter: menuPresenter,
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
      );

      expect(sut.indexOfSelectedProduct, null);
    });

    test(
        "Should update product quantity when add equal product in cart instead of add other product",
        () async {
      await sut.addProductInCart(
        product: cartProductEntity,
        menuPresenter: menuPresenter,
      );
      await sut.addProductInCart(
        product: cartProductEntity,
        menuPresenter: menuPresenter,
      );

      expect(sut.cartProducts.length, 1);
    });

    test(
        "Should add new product in cart if already contains equal PLU in cart but the comment is differente",
        () async {
      await sut.addProductInCart(
        product: cartProductEntity,
        menuPresenter: menuPresenter,
      );

      final productWithNewComment = CartProductEntity(
        Product: cartProductEntity.Product,
        Comments: "comentário diferente",
        TotalLiquid: cartProductEntity.TotalLiquid,
        Quantity: cartProductEntity.Quantity,
        Value: cartProductEntity.Value,
        ProductPriceLookUpCode: cartProductEntity.ProductPriceLookUpCode,
      );
      await sut.addProductInCart(
        product: productWithNewComment,
        menuPresenter: menuPresenter,
      );

      expect(sut.cartProducts.length, 2);
    });

    test(
        "Should add new product in cart if already contains equal PLU in cart but the value is differente",
        () async {
      await sut.addProductInCart(
        product: cartProductEntity,
        menuPresenter: menuPresenter,
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
      );

      expect(sut.cartProducts.length, 2);
    });
  });

  group("Save cart products in saleRequesTemp", () {
    test("Should call correct functions on save products in SaleRequestTemp",
        () async {
      confirmedCartProducts.mockIsConfirmed(false);
      await sut.saveProducts(printedProductsPresenter);

      verify(() => barcodeScanner.read()).called(1);

      verify(() => ticketIsPermitted.verify(
            url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
            commandNumber: commandNumber,
          )).called(1);

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

      verify(() => updateSaleRequestTemp.update(
            url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
            entity: updateSaleRequestTempEntity,
          )).called(1);

      verify(() => finishSaleRequestTemp.finish(
            saleRequestTempEntity: saleRequestTempEntity,
            url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
          )).called(1);
      verify(() => printedProductsPresenter.loadPrinted(commandNumber))
          .called(1);
    });
    test("Should emit correct values on success to save cart products",
        () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.mainErrorStream, emits(null));

      await sut.saveProducts(printedProductsPresenter);
    });
    test("Should emit correct values on BarcodeScanner throws unexpected",
        () async {
      barcodeScanner.mockError(DomainError.unexpected);
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));

      await sut.saveProducts(printedProductsPresenter);
    });
    test("Should emit correct values on BarcodeScanner throws BarcodeNotRead",
        () async {
      barcodeScanner.mockError(DomainError.barcodeNotRead);
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.barcodeNotRead]));

      await sut.saveProducts(printedProductsPresenter);
    });
    test("Should emit correct values LoadSaleRequestTemp throws", () async {
      loadSaleRequestTemp.mockError(DomainError.unexpected);
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));

      await sut.saveProducts(printedProductsPresenter);
    });
    test("Should call correct functions LoadSaleRequestTemp throws", () async {
      loadSaleRequestTemp.mockError(DomainError.unexpected);

      await sut.saveProducts(printedProductsPresenter);

      verify(() => ticketIsPermitted.verify(
            url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
            commandNumber: commandNumber,
          )).called(1);

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
    test("Should emit correct values TicketIsPermited throws", () async {
      ticketIsPermitted.mockError();
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.mainErrorStream,
          emitsInOrder([null, UIError.commandNotAvailable]));

      await sut.saveProducts(printedProductsPresenter);
    });
    test("Should call correct functions when TicketIsPermited throws",
        () async {
      ticketIsPermitted.mockError();

      await sut.saveProducts(printedProductsPresenter);

      verify(() => ticketIsPermitted.verify(
            url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
            commandNumber: commandNumber,
          )).called(1);

      verifyNever(
        () => loadSaleRequestTemp.load(
          url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
          enterpriseId:
              EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId!,
          commandNumber: commandNumber,
        ),
      );

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
      await sut.saveProducts(printedProductsPresenter);
    });
    test("Should call correct functions updateSaleRequestTemp throws",
        () async {
      updateSaleRequestTemp
          .mockUpdateSaleRequestTempError(DomainError.unexpected);
      confirmedCartProducts.mockIsConfirmed(false);

      await sut.saveProducts(printedProductsPresenter);

      verify(() => ticketIsPermitted.verify(
            url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
            commandNumber: commandNumber,
          )).called(1);

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

      await sut.saveProducts(printedProductsPresenter);
    });
    test("Should call correct functions when finishSaleRequestTemp throws",
        () async {
      finishSaleRequestTemp.mockFinishSaleRequestTempError();

      await sut.saveProducts(printedProductsPresenter);

      verify(() => ticketIsPermitted.verify(
            url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
            commandNumber: commandNumber,
          )).called(1);

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
      await sut.saveProducts(printedProductsPresenter);

      verify(() => confirmedCartProducts.isConfirmed()).called(1);
    });
    test(
        "Should call udpate confirmedCartProducts with true value when saveCartProducts succeeds",
        () async {
      await sut.saveProducts(printedProductsPresenter);

      verify(() => confirmedCartProducts.updateValue(true)).called(1);
    });
    test(
        "Should NOT call udpate confirmedCartProducts with true value when updateSaleRequest throws",
        () async {
      confirmedCartProducts.mockIsConfirmed(false);
      updateSaleRequestTemp
          .mockUpdateSaleRequestTempError(DomainError.unexpected);
      await sut.saveProducts(printedProductsPresenter);

      verifyNever(() => confirmedCartProducts.updateValue(true));
    });
    test(
        "Should call udpate confirmedCartProducts with false value when finishSaleRequestTemp succeeds",
        () async {
      await sut.saveProducts(printedProductsPresenter);

      verify(() => confirmedCartProducts.updateValue(false)).called(1);
    });
    test(
        "Should NOT call udpate confirmedCartProducts with false value when finishSaleRequestTemp throws",
        () async {
      finishSaleRequestTemp.mockFinishSaleRequestTempError();

      await sut.saveProducts(printedProductsPresenter);

      verifyNever(() => confirmedCartProducts.updateValue(false));
    });
    test(
        "Should not call updateSaleRequestTemp when confirmedCartProducts return true",
        () async {
      confirmedCartProducts.mockIsConfirmed(true);
      await sut.saveProducts(printedProductsPresenter);

      verifyNever(() => updateSaleRequestTemp.update(
            url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
            entity: updateSaleRequestTempEntity,
          ));
    });
    test(
        "Should call updateSaleRequestTemp when confirmedCartProducts return false",
        () async {
      confirmedCartProducts.mockIsConfirmed(false);
      await sut.saveProducts(printedProductsPresenter);

      verify(() => updateSaleRequestTemp.update(
            url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
            entity: updateSaleRequestTempEntity,
          )).called(1);
    });
    test("Should clear cartProducts on saveProducts succeeds", () async {
      sut.addProductInCart(
        product: cartProductEntity,
        menuPresenter: menuPresenter,
      );

      await sut.saveProducts(printedProductsPresenter);

      expect(sut.cartProducts, []);
    });
    test("Should return true on saveProducts succeeds", () async {
      final isUpdated = await sut.saveProducts(printedProductsPresenter);

      expect(isUpdated, true);
    });
    test("Should return false on saveProducts throws", () async {
      ticketIsPermitted.mockError();

      final isUpdated = await sut.saveProducts(printedProductsPresenter);

      expect(isUpdated, false);
    });

    test("Should return false on saveProducts throws", () async {
      ticketIsPermitted.mockError();

      final isUpdated = await sut.saveProducts(printedProductsPresenter);

      expect(isUpdated, false);
    });
  });

  group("Confirmed combox products", () {
    test("Should emit correct values on addConfirmedCombox success", () async {
      expectLater(sut.mainErrorStream, emits(null));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.addConfirmedCombox(
        selectedChilds: [selectedChildWithOneQuantity],
        totalPrice: 10,
        father: fatherOfCombox,
        quantity: 1,
      );
    });
    test("Should emit correct values on addConfirmedCombox throws", () async {
      cartInformations.mockUpdateConfirmedComboxError();
      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.addConfirmedCombox(
        selectedChilds: [selectedChildWithOneQuantity],
        totalPrice: 10,
        father: fatherOfCombox,
        quantity: 1,
      );
    });
    test("Should add new ConfirmedComboxViewModel with one quantity correctly",
        () async {
      await sut.addConfirmedCombox(
        selectedChilds: [selectedChildWithOneQuantity],
        totalPrice: 10,
        father: fatherOfCombox,
        quantity: 1,
      );

      expect(sut.confirmedCombox, [confirmedComboxWithOneQuantity]);
    });

    test("Should not add ConfirmedComboxViewModel if not selected", () async {
      await sut.addConfirmedCombox(
        selectedChilds: [notSelectedChild, selectedChildWithOneQuantity],
        totalPrice: 10,
        father: fatherOfCombox,
        quantity: 1,
      );

      expect(sut.confirmedCombox, [confirmedComboxWithOneQuantity]);
    });
    test(
        "Should add new ConfirmedComboxViewModel with two quantities correctly",
        () async {
      await sut.addConfirmedCombox(
        selectedChilds: [selectedChildWithTwoQuantities],
        totalPrice: confirmedComboxWithtwoQuantities.totalPrice,
        father: confirmedComboxWithtwoQuantities.father,
        quantity: confirmedComboxWithtwoQuantities.quantity,
      );

      expect(sut.confirmedCombox, [confirmedComboxWithtwoQuantities]);
    });

    test("Should return true on addConfirmedCombox success", () async {
      bool isConfirmed = await sut.addConfirmedCombox(
        selectedChilds: [selectedChildWithOneQuantity],
        totalPrice: 10,
        father: fatherOfCombox,
        quantity: 1,
      );

      expect(isConfirmed, true);
    });
    test("Should return false on addConfirmedCombox throws", () async {
      cartInformations.mockUpdateConfirmedComboxError();

      bool isConfirmed = await sut.addConfirmedCombox(
        selectedChilds: [selectedChildWithOneQuantity],
        totalPrice: 10,
        father: fatherOfCombox,
        quantity: 1,
      );

      expect(isConfirmed, false);
    });

    test(
        "Should call cartInformations.updateConfirmedCombox on addConfirmedCombox with one quantity",
        () async {
      await sut.addConfirmedCombox(
        selectedChilds: [selectedChildWithOneQuantity]
            .map((element) => ProductCompositionViewModel(
                  Quantity: 1.0.toString(),
                  ProductCompositionId: element.ProductCompositionId,
                  EnterpriseId: element.EnterpriseId,
                  InternalCodeOnERPCodeFather:
                      element.InternalCodeOnERPCodeFather,
                  InternalCodeOnERPCodeChild:
                      element.InternalCodeOnERPCodeChild,
                  PluChild: element.PluChild,
                  ChildName: element.ChildName,
                  SalePrice: element.SalePrice,
                  OfferPrice: element.OfferPrice,
                  IncrementValue: element.IncrementValue,
                  IsOptionalItem: element.IsOptionalItem,
                  ProductOptions: element.ProductOptions,
                  childs: element.childs,
                  commentFather: element.commentFather,
                  indexOfSelectedChild: element.indexOfSelectedChild,
                ))
            .toList(),
        totalPrice: 10,
        father: fatherOfCombox,
        quantity: 1,
      );

      verify(() => cartInformations
          .updateConfirmedCombox([confirmedComboxWithOneQuantity])).called(1);
    });
    test(
        "Should call cartInformations.updateConfirmedCombox on addConfirmedCombox with 2 quantities",
        () async {
      await sut.addConfirmedCombox(
        selectedChilds: [selectedChildWithOneQuantity],
        totalPrice: 10,
        father: fatherOfCombox,
        quantity: 1,
      );

      verify(() => cartInformations
          .updateConfirmedCombox([confirmedComboxWithOneQuantity])).called(1);
    });

    test("Should emit correct values on getLocalConfirmedsCombox success",
        () async {
      expectLater(sut.mainErrorStream, emits(null));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.getLocalConfirmedsCombox();
    });

    test("Should emit correct values on getLocalConfirmedsCombox throws",
        () async {
      cartInformations.mockGetConfirmedsComboxError();

      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.getLocalConfirmedsCombox();
    });

    test("Should update confirmedCombox with correct local values", () async {
      expect(sut.confirmedCombox, []);

      await sut.getLocalConfirmedsCombox();

      expect(sut.confirmedCombox, [confirmedComboxWithOneQuantity]);
    });

    test("Should emit correct values on addComboxQuantity succeeds", () async {
      cartInformations.mockUpdateConfirmedComboxError();

      expectLater(sut.mainErrorStream, emits(null));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.addComboxQuantity(0);
    });

    test("Should emit correct values on addComboxQuantity throws", () async {
      cartInformations.mockUpdateConfirmedComboxError();

      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.addComboxQuantity(0);
    });

    test(
        "Should call updateConfirmedCombox correctly on addComboxQuantity with one quantity",
        () async {
      sut.confirmedCombox.add(confirmedComboxWithOneQuantity);

      await sut.addComboxQuantity(0);

      verify(() => cartInformations.updateConfirmedCombox(
            [
              ConfirmedComboxViewModel(
                products: [selectedChildWithOneQuantity]
                    .map((element) => ProductCompositionViewModel(
                          Quantity: (element.Quantity.toString().toDouble() + 1)
                              .toString(),
                          ProductCompositionId: element.ProductCompositionId,
                          EnterpriseId: element.EnterpriseId,
                          InternalCodeOnERPCodeFather:
                              element.InternalCodeOnERPCodeFather,
                          InternalCodeOnERPCodeChild:
                              element.InternalCodeOnERPCodeChild,
                          PluChild: element.PluChild,
                          ChildName: element.ChildName,
                          SalePrice: element.SalePrice,
                          OfferPrice: element.OfferPrice,
                          IncrementValue: element.IncrementValue,
                          IsOptionalItem: element.IsOptionalItem,
                          ProductOptions: element.ProductOptions,
                          childs: element.childs,
                          commentFather: element.commentFather,
                          indexOfSelectedChild: element.indexOfSelectedChild,
                        ))
                    .toList(),
                father: confirmedComboxWithOneQuantity.father,
                totalPrice: confirmedComboxWithOneQuantity.totalPrice,
                quantity: confirmedComboxWithOneQuantity.quantity + 1,
              )
            ],
          )).called(1);
    });
    test(
        "Should call updateConfirmedCombox correctly on addComboxQuantity with 2 quantities",
        () async {
      sut.confirmedCombox.add(confirmedComboxWithtwoQuantities);

      await sut.addComboxQuantity(0);

      verify(() => cartInformations.updateConfirmedCombox(
            [
              ConfirmedComboxViewModel(
                products: [selectedChildWithTwoQuantities]
                    .map((element) => ProductCompositionViewModel(
                          Quantity: 6.0.toString(),
                          ProductCompositionId: element.ProductCompositionId,
                          EnterpriseId: element.EnterpriseId,
                          InternalCodeOnERPCodeFather:
                              element.InternalCodeOnERPCodeFather,
                          InternalCodeOnERPCodeChild:
                              element.InternalCodeOnERPCodeChild,
                          PluChild: element.PluChild,
                          ChildName: element.ChildName,
                          SalePrice: element.SalePrice,
                          OfferPrice: element.OfferPrice,
                          IncrementValue: element.IncrementValue,
                          IsOptionalItem: element.IsOptionalItem,
                          ProductOptions: element.ProductOptions,
                          childs: element.childs,
                          commentFather: element.commentFather,
                          indexOfSelectedChild: element.indexOfSelectedChild,
                        ))
                    .toList(),
                father: confirmedComboxWithtwoQuantities.father,
                totalPrice: confirmedComboxWithtwoQuantities.totalPrice,
                quantity: 3.0,
              )
            ],
          )).called(1);
    });

    test("Should add new combox quantity correctly", () async {
      sut.confirmedCombox.add(confirmedComboxWithOneQuantity);

      await sut.addComboxQuantity(0);

      expect(sut.confirmedCombox[0].totalPrice, 10);
      expect(sut.confirmedCombox[0].quantity, 2);
      expect(sut.confirmedCombox[0].products.first.Quantity, "2.0");
    });

    test("Should add new combox quantity correctly ²", () async {
      sut.confirmedCombox.add(confirmedComboxWithtwoQuantities);

      await sut.addComboxQuantity(0);

      expect(sut.confirmedCombox[0].totalPrice, 20);
      expect(sut.confirmedCombox[0].quantity, 3);
      expect(sut.confirmedCombox[0].products.first.Quantity, "6.0");
    });

    test("Should emit correct values on subtract combox quantity succeeds",
        () async {
      expectLater(sut.mainErrorStream, emits(null));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.reduceComboxQuantity(0);
    });

    test("Should emit correct values on subtract combox quantity throws",
        () async {
      cartInformations.mockUpdateConfirmedComboxError();

      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.reduceComboxQuantity(0);
    });

    test(
        "Should call cartInformations.updateConfirmedCombox when reduce quantity",
        () async {
      sut.confirmedCombox.add(confirmedComboxWithtwoQuantities);

      await sut.reduceComboxQuantity(0);

      verify(() => cartInformations.updateConfirmedCombox(
            [
              ConfirmedComboxViewModel(
                products: [selectedChildWithTwoQuantities]
                    .map((element) => ProductCompositionViewModel(
                          Quantity: 2.0.toString(),
                          ProductCompositionId: element.ProductCompositionId,
                          EnterpriseId: element.EnterpriseId,
                          InternalCodeOnERPCodeFather:
                              element.InternalCodeOnERPCodeFather,
                          InternalCodeOnERPCodeChild:
                              element.InternalCodeOnERPCodeChild,
                          PluChild: element.PluChild,
                          ChildName: element.ChildName,
                          SalePrice: element.SalePrice,
                          OfferPrice: element.OfferPrice,
                          IncrementValue: element.IncrementValue,
                          IsOptionalItem: element.IsOptionalItem,
                          ProductOptions: element.ProductOptions,
                          childs: element.childs,
                          commentFather: element.commentFather,
                          indexOfSelectedChild: element.indexOfSelectedChild,
                        ))
                    .toList(),
                father: confirmedComboxWithtwoQuantities.father,
                totalPrice: confirmedComboxWithtwoQuantities.totalPrice,
                quantity: 1.0,
              ),
            ],
          )).called(1);
    });

    test(
        "Should remove combox when subtract and have only one quantity or less",
        () async {
      sut.confirmedCombox.add(confirmedComboxWithOneQuantity);

      await sut.reduceComboxQuantity(0);

      expect(sut.confirmedCombox, []);
    });

    test(
        "Should reduce combox quantity correctly when have more than 1 combox quantity",
        () async {
      sut.confirmedCombox.add(confirmedComboxWithtwoQuantities);

      await sut.reduceComboxQuantity(0);

      expect(sut.confirmedCombox, [
        ConfirmedComboxViewModel(
          products: [selectedChildWithTwoQuantities]
              .map((element) => ProductCompositionViewModel(
                    Quantity: 2.0.toString(),
                    ProductCompositionId: element.ProductCompositionId,
                    EnterpriseId: element.EnterpriseId,
                    InternalCodeOnERPCodeFather:
                        element.InternalCodeOnERPCodeFather,
                    InternalCodeOnERPCodeChild:
                        element.InternalCodeOnERPCodeChild,
                    PluChild: element.PluChild,
                    ChildName: element.ChildName,
                    SalePrice: element.SalePrice,
                    OfferPrice: element.OfferPrice,
                    IncrementValue: element.IncrementValue,
                    IsOptionalItem: element.IsOptionalItem,
                    ProductOptions: element.ProductOptions,
                    childs: element.childs,
                    commentFather: element.commentFather,
                    indexOfSelectedChild: element.indexOfSelectedChild,
                  ))
              .toList(),
          father: confirmedComboxWithtwoQuantities.father,
          totalPrice: confirmedComboxWithtwoQuantities.totalPrice,
          quantity: 1.0,
        ),
      ]);
    });

    test("Should emit correct values on update combox comment succeeds",
        () async {
      expectLater(sut.mainErrorStream, emits(null));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.updateCommentOfCombox(
        indexOfCombox: 0,
        indexOfProduct: 0,
        newComment: newComment,
      );
    });

    test("Should emit correct values on update combox comment throws",
        () async {
      cartInformations.mockUpdateConfirmedComboxError();

      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.updateCommentOfCombox(
        indexOfCombox: 0,
        indexOfProduct: 0,
        newComment: newComment,
      );
    });

    test(
        "Should call cartInformations.updateConfirmedCombox when update comment",
        () async {
      sut.confirmedCombox.add(confirmedComboxWithOneQuantity);

      await sut.updateCommentOfCombox(
          indexOfCombox: 0, indexOfProduct: 0, newComment: newComment);

      verify(() => cartInformations.updateConfirmedCombox([
            ConfirmedComboxViewModel(
              products: confirmedComboxWithOneQuantity.products
                  .map((element) => ProductCompositionViewModel(
                        commentFather: newComment,
                        ProductCompositionId: element.ProductCompositionId,
                        EnterpriseId: element.EnterpriseId,
                        InternalCodeOnERPCodeFather:
                            element.InternalCodeOnERPCodeFather,
                        InternalCodeOnERPCodeChild:
                            element.InternalCodeOnERPCodeChild,
                        PluChild: element.PluChild,
                        ChildName: element.ChildName,
                        Quantity: element.Quantity,
                        SalePrice: element.SalePrice,
                        OfferPrice: element.OfferPrice,
                        IncrementValue: element.IncrementValue,
                        IsOptionalItem: element.IsOptionalItem,
                        ProductOptions: element.ProductOptions,
                        childs: element.childs,
                        indexOfSelectedChild: element.indexOfSelectedChild,
                      ))
                  .toList(),
              father: confirmedComboxWithOneQuantity.father,
              totalPrice: confirmedComboxWithOneQuantity.totalPrice,
              quantity: confirmedComboxWithOneQuantity.quantity,
            )
          ])).called(1);
    });

    test("Should update comment correctly", () async {
      sut.confirmedCombox.add(confirmedComboxWithOneQuantity);

      await sut.updateCommentOfCombox(
        indexOfCombox: 0,
        indexOfProduct: 0,
        newComment: newComment,
      );

      expect(
        sut.confirmedCombox.first.products.first.commentFather,
        newComment,
      );
    });
    test("Should clear comment correctly", () async {
      sut.confirmedCombox.add(confirmedComboxWithOneQuantity);

      await sut.updateCommentOfCombox(
        indexOfCombox: 0,
        indexOfProduct: 0,
        newComment: null,
      );

      expect(
        sut.confirmedCombox.first.products.first.commentFather,
        null,
      );
    });

    test("Should update indexOfSelectedCombox correctly", () async {
      expect(sut.indexOfSelectedProductCombox, null);

      sut.updateIndexOfSelectedProductCombox(1);
      expect(sut.indexOfSelectedProductCombox, 1);

      sut.updateIndexOfSelectedProductCombox(1);
      expect(sut.indexOfSelectedProductCombox, null);
    });

    test("Should remove indexOfSelectedCombox when update comment succeeds",
        () async {
      sut.confirmedCombox.add(confirmedComboxWithOneQuantity);
      sut.updateIndexOfSelectedProductCombox(0);

      await sut.updateCommentOfCombox(
        indexOfCombox: 0,
        indexOfProduct: 0,
        newComment: newComment,
      );

      expect(sut.indexOfSelectedProductCombox, null);
    });

    test("Should return incrementValue when is optionalItem", () async {
      double price = sut
          .calculateProductPrice(EntityFactory.makeProductCompositionViewModel(
        quantity: 1,
        salePrice: 10,
        offerPrice: 15,
        incrementValue: 0,
        isOptionalItem: true,
        indexOfSelectedChild: null,
      ));

      expect(price, 0);
    });

    test(
        "Should offerPrice + incrementValue when offer is more than 0 and is not optional item",
        () async {
      double price = sut
          .calculateProductPrice(EntityFactory.makeProductCompositionViewModel(
        quantity: 1,
        salePrice: 10,
        offerPrice: 15,
        incrementValue: 10,
        isOptionalItem: false,
        indexOfSelectedChild: null,
      ));

      expect(price, 25);
    });

    test(
        "Should SalePrice + incrementValue when offer is less than 0 and is not optional item",
        () async {
      double price = sut
          .calculateProductPrice(EntityFactory.makeProductCompositionViewModel(
        quantity: 1,
        salePrice: 10,
        offerPrice: 0,
        incrementValue: 10,
        isOptionalItem: false,
        indexOfSelectedChild: null,
      ));

      expect(price, 20);
    });
  });
}
