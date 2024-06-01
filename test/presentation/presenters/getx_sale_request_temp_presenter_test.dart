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
  late GetxSaleRequestTempPresenter sut;
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

  late SaleRequestTempEntity saleRequestTempEntity;
  late int saleRequestProductTempId;
  late String comments;
  late PrintRequestEntity printRequestEntity;
  late CartProductEntity cartProductEntity;

  void initUsecases() {
    loadSaleRequestTemp = LoadSaleRequestTempSpy();
    updateProductQuantity = UpdateProductQuantitySpy();
    updateProductComment = UpdateProductCommentSpy();
    finishSaleRequestTemp = FinishSaleRequestTempSpy();
    ticketIsPermitted = TicketIsPermittedSpy();
    addPrintRequest = AddPrintRequestSpy();
    localPrintRequest = LocalPrintRequestSpy();
  }

  void initPresenters() {
    menuPresenter = MenuPresenterSpy();
    printedProductsPresenter = PrintedProductsPresenterSpy();
    homePresenter = HomePresenterSpy();

    sut = GetxSaleRequestTempPresenter(
      loadSaleRequestTemp: loadSaleRequestTemp,
      updateProductQuantity: updateProductQuantity,
      updateProductComment: updateProductComment,
      finishSaleRequestTemp: finishSaleRequestTemp,
      ticketIsPermitted: ticketIsPermitted,
      addPrintRequest: addPrintRequest,
      localPrintRequest: localPrintRequest,
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
  }

  void initMockSuccess() {
    loadSaleRequestTemp.mockLoadSaleRequestTemp(saleRequestTempEntity);
    localPrintRequest.mockGetMergedPrinted(null);
  }

  setUp(() {
    initUsecases();
    initPresenters();
    initEntitys();
    initMockSuccess();
  });

  setUpAll(() {
    registerFallbackValue(PrintedProductsPresenterSpy());
    registerFallbackValue(SaleRequestTempPresenterSpy());
    registerFallbackValue(MenuPresenterSpy());
    registerFallbackValue(EntityFactory.makeSaleRequestTempEntity());
    registerFallbackValue(EntityFactory.makePrintRequestEntity());
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
      );
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
        saleRequestTempPresenter: sut,
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
        saleRequestTempPresenter: sut,
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
        saleRequestTempPresenter: sut,
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
        saleRequestTempPresenter: sut,
        homePresenter: homePresenter,
      );
    });

    test("Should clear selectedProductIndex on success to UpdateComment",
        () async {
      sut.updateIndexOfSelectedProduct(1);

      expect(sut.indexOfSelectedProduct, 1);
      await sut.updateComment(
        comments: comments,
        saleRequestProductTempId: saleRequestProductTempId,
        menuPresenter: menuPresenter,
        printedProductsPresenter: printedProductsPresenter,
        saleRequestTempPresenter: sut,
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
        saleRequestTempPresenter: sut,
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
        saleRequestTempPresenter: sut,
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
        saleRequestTempPresenter: sut,
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
        saleRequestTempPresenter: sut,
        homePresenter: homePresenter,
      );
    });

    test("Should call MenuPresenter.load on FinishSaleRequest success",
        () async {
      await sut.finishSaleRequest(
        saleRequestTempEntity: saleRequestTempEntity,
        menuPresenter: menuPresenter,
        printedProductsPresenter: printedProductsPresenter,
        saleRequestTempPresenter: sut,
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
        saleRequestTempPresenter: sut,
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
        saleRequestTempPresenter: sut,
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
        saleRequestTempPresenter: sut,
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
        saleRequestTempPresenter: sut,
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
        saleRequestTempPresenter: sut,
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
        saleRequestTempPresenter: sut,
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
        saleRequestTempPresenter: sut,
        menuPresenter: menuPresenter,
        homePresenter: homePresenter,
      );
    });

    test(
        "Should emit correct values on loadCommandData throws commandNotAvailable",
        () async {
      ticketIsPermitted.mockError(DomainError.commandNotAvailable);

      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.mainErrorStream,
          emitsInOrder([null, UIError.commandNotAvailable]));

      await sut.loadCommandData(
        commandNumber: homePresenter.commandNumberMock!,
        printedProductsPresenter: printedProductsPresenter,
        saleRequestTempPresenter: sut,
        menuPresenter: menuPresenter,
        homePresenter: homePresenter,
      );
    });

    test("Should emit correct values on loadCommandData throws", () async {
      ticketIsPermitted.mockError(DomainError.unexpected);

      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));

      await sut.loadCommandData(
        commandNumber: homePresenter.commandNumberMock!,
        printedProductsPresenter: printedProductsPresenter,
        saleRequestTempPresenter: sut,
        menuPresenter: menuPresenter,
        homePresenter: homePresenter,
      );
    });

    test("Should update commandNumber", () async {
      homePresenter.commandNumberMock = "9999";

      await sut.loadCommandData(
        commandNumber: homePresenter.commandNumberMock!,
        printedProductsPresenter: printedProductsPresenter,
        saleRequestTempPresenter: sut,
        menuPresenter: menuPresenter,
        homePresenter: homePresenter,
      );

      expect(homePresenter.commandNumberMock, "9999");
    });

    test("Should call clearData on LoadCommandData call", () async {
      await sut.loadCommandData(
        commandNumber: homePresenter.commandNumberMock!,
        printedProductsPresenter: printedProductsPresenter,
        saleRequestTempPresenter: sut,
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
        saleRequestTempPresenter: sut,
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
        saleRequestTempPresenter: sut,
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
        saleRequestTempPresenter: sut,
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
      ticketIsPermitted.mockError(DomainError.unexpected);

      await sut.loadCommandData(
        commandNumber: homePresenter.commandNumberMock!,
        printedProductsPresenter: printedProductsPresenter,
        saleRequestTempPresenter: sut,
        menuPresenter: menuPresenter,
        homePresenter: homePresenter,
      );

      verify(() => homePresenter.updateCommandNumber(null)).called(1);
    });
  });

  group("Cart products", () {
    test("Should add correctly CartProduct", () {
      expect(sut.cartProducts, []);

      sut.addProductInCart(
        product: cartProductEntity,
        menuPresenter: menuPresenter,
      );

      expect(sut.cartProducts,
          [CartProductsViewModel.fromEntity(cartProductEntity)]);
    });
    test("Should remove correct product from cart", () {
      expect(sut.cartProducts, []);
      final cartProduct1 = EntityFactory.makeCartProductEntity(
        maximumProductQuantity: 100, //tanto faz pra esse teste
        minimumProductQuantity: 1, //tanto faz pra esse teste
      );

      sut.addProductInCart(
        product: cartProductEntity,
        menuPresenter: menuPresenter,
      );
      sut.addProductInCart(
        product: cartProduct1,
        menuPresenter: menuPresenter,
      );

      expect(sut.cartProducts, [
        CartProductsViewModel.fromEntity(cartProductEntity), //0
        CartProductsViewModel.fromEntity(cartProduct1), //1
      ]);

      sut.removeProductFromCart(0);
      expect(
          sut.cartProducts, [CartProductsViewModel.fromEntity(cartProduct1)]);

      sut.removeProductFromCart(0);
      expect(sut.cartProducts, []);
    });

    test("Should update comment correctly", () {
      sut.addProductInCart(
        product: cartProductEntity,
        menuPresenter: menuPresenter,
      );

      final newComment = faker.randomGenerator.string(20);
      sut.updateCommentOfProductCart(index: 0, newComment: newComment);

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

    test("Should reduce quantity correctly", () {
      sut.addProductInCart(
        product: cartProductEntity,
        menuPresenter: menuPresenter,
      );
      sut.addProductInCart(
        product: EntityFactory.makeCartProductEntity(
          maximumProductQuantity: 1,
          minimumProductQuantity: 1,
        ),
        menuPresenter: menuPresenter,
      );

      sut.reduceCartProductQuantity(0);
      expect(sut.cartProducts[0].Quantity,
          (cartProductEntity.Quantity - 1).toString());

      sut.reduceCartProductQuantity(1);
      expect(sut.cartProducts.length, 1);
    });

    test("Should clear indexOfSelectedProduct when add a product", () {
      sut.addProductInCart(
        product: cartProductEntity,
        menuPresenter: menuPresenter,
      );

      expect(sut.indexOfSelectedProduct, null);
    });
  });
}
