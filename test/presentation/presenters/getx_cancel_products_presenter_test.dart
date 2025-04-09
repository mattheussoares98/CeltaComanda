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
  late GetxCancelProductsPresenter sut;
  late CartPresenterSpy cartPresenter;
  late HomePresenterSpy homePresenter;

  late RemovePrintedProductSpy removePrintedProduct;
  late LoadPrintedProductsSpy loadPrintedProducts;
  late UpdateSaleRequestSpy updateSaleRequest;

  late int commandNumber;
  late PrintedEntity printedEntity;
  late PrintedViewModel printedViewModel;

  void initUsecases() {
    removePrintedProduct = RemovePrintedProductSpy();
    loadPrintedProducts = LoadPrintedProductsSpy();
    updateSaleRequest = UpdateSaleRequestSpy();
  }

  void initPresenters() {
    cartPresenter = CartPresenterSpy();
    homePresenter = HomePresenterSpy();
    sut = GetxCancelProductsPresenter(
      removePrintedProduct: removePrintedProduct,
      loadPrintedProducts: loadPrintedProducts,
      updateSaleRequest: updateSaleRequest,
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
    registerFallbackValue(
      EntityFactory.makeSaleRequestModel(covenantCode: 0, customerCode: 0),
    );
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
  });
  group("Cancel product", () {
    test("Should emit correct values on success", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.mainErrorStream, emits(null));

      await sut.cancelProduct(
        UserIdOfCancellation: faker.randomGenerator.integer(100),
        printedModel: PrintedModel.fromViewModel(printedViewModel),
        product: printedViewModel.Products[0],
        commandNumber: commandNumber,
        showSuccessMessage: () {},
        cartPresenter: cartPresenter,
        homePresenter: homePresenter,
      );
    });
    test("Should emit correct values on error", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));

      updateSaleRequest.mockUpdateSaleRequestError(DomainError.unexpected);
      removePrintedProduct.mockError();

      await sut.cancelProduct(
        UserIdOfCancellation: faker.randomGenerator.integer(100),
        printedModel: PrintedModel.fromViewModel(printedViewModel),
        product: printedViewModel.Products[0],
        commandNumber: commandNumber,
        showSuccessMessage: () {},
        cartPresenter: cartPresenter,
        homePresenter: homePresenter,
      );
    });
    test("Should call updateSaleRequest with correct value", () async {
      final userIdOfCancellation = faker.randomGenerator.integer(100);

      await sut.cancelProduct(
        UserIdOfCancellation: userIdOfCancellation,
        printedModel: PrintedModel.fromViewModel(printedViewModel),
        product: printedViewModel.Products[0],
        commandNumber: commandNumber,
        showSuccessMessage: () {},
        cartPresenter: cartPresenter,
        homePresenter: homePresenter,
      );

      PrintedModel printedModel = PrintedModel.fromViewModel(printedViewModel);

      verify(() => updateSaleRequest.update(
            commandNumber: commandNumber.toString(),
            saleRequestId: printedViewModel.SaleRequestId!.toInt(),
            model: SaleRequestModel(
              Products:
                  PrintedModel.fromViewModel(printedViewModel).Products.map(
                (e) {
                  final bool isSameProduct = printedViewModel
                          .Products[0].SaleRequestProductId
                          ?.toInt() ==
                      e.SaleRequestProductId;

                  return SaleRequestProductModel.fromEntity(
                    SaleRequestProductEntity(
                      ProductIsFatherComposition: e.ProductIsFatherComposition,
                      IsCancelled: isSameProduct == true ? true : e.IsCancelled,
                      UserIdOfCancellation: isSameProduct
                          ? userIdOfCancellation
                          : e.UserIdOfCancellation,
                      Product: e.Product,
                      SaleMovementProductCompositionId:
                          e.SaleMovementProductCompositionId,
                      ProductPriceLookUpCode: e.ProductPriceLookUpCode,
                      QuantityString: e.QuantityString,
                      Comments: e.Comments,
                      DateHourOfCreation: e.DateHourOfCreation,
                      IsDelivered: e.IsDelivered,
                      IsPrinted: e.IsPrinted,
                      SaleRequestProductId: e.SaleRequestProductId,
                      UserId: e.UserId,
                      ProductionStatus: e.ProductionStatus,
                      ProductInternalCodeOnErp: e.ProductInternalCodeOnErp,
                      SaleRequestId: e.SaleRequestId,
                      Value: e.Value,
                      Quantity: e.Quantity,
                      TotalLiquid: e.TotalLiquid,
                    ),
                  );
                },
              ).toList(),
              DateOfCreation: printedModel.DateOfCreation,
              DateHourOfCreation: printedModel.DateHourOfCreation,
              RequestType: printedModel.RequestType,
              FlagStatus: printedModel.FlagStatus,
              Comments: printedModel.Comments,
              PersonalizedCode: printedModel.PersonalizedCode,
              SellerCode: printedModel.SellerCode,
              IsCancelled: printedModel.IsCancelled,
              IsUsing: printedModel.IsUsing,
              TotalLiquid: printedModel.TotalLiquid,
              CovenantCode: printedModel.CovenantCode,
              CustomerCode: printedModel.CustomerCode,
              EnterpriseId: printedModel.EnterpriseId,
              Peoples: printedModel.Peoples,
              FlagOrigin: printedModel.FlagOrigin,
              DeliveryControl: printedModel.DeliveryControl,
              SaleRequestId: printedModel.SaleRequestId,
              IncrementValue: printedModel.IncrementValue,
              IncrementType: printedModel.IncrementType,
            ),
          )).called(1);
    });
  });

  test("Should update increment value", () async {
    await sut.cancelProduct(
      UserIdOfCancellation: faker.randomGenerator.integer(100),
      printedModel: PrintedModel.fromViewModel(printedViewModel),
      product: printedViewModel.Products[0],
      commandNumber: commandNumber,
      showSuccessMessage: () {},
      cartPresenter: cartPresenter,
      homePresenter: homePresenter,
    );

    verify(() => cartPresenter.updateIncrementValue(commandNumber.toString()))
        .called(1);
  });
  test("Should not update increment value if increment type is not 1",
      () async {
    printedViewModel = PrintedViewModel.fromEntity(
      EntityFactory.makePrintedEntity(incrementType: 0),
    );

    await sut.cancelProduct(
      UserIdOfCancellation: faker.randomGenerator.integer(100),
      printedModel: PrintedModel.fromViewModel(printedViewModel),
      product: printedViewModel.Products[0],
      commandNumber: commandNumber,
      showSuccessMessage: () {},
      cartPresenter: cartPresenter,
      homePresenter: homePresenter,
    );

    verifyNever(
        () => cartPresenter.updateIncrementValue(commandNumber.toString()));
  });
}
