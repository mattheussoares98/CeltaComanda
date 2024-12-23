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

  late int commandNumber;
  late PrintedEntity printedEntity;
  late PrintedViewModel printedViewModel;

  void initUsecases() {
    removePrintedProduct = RemovePrintedProductSpy();
    loadPrintedProducts = LoadPrintedProductsSpy();
  }

  void initPresenters() {
    cartPresenter = CartPresenterSpy();
    homePresenter = HomePresenterSpy();
    sut = GetxCancelProductsPresenter(
      removePrintedProduct: removePrintedProduct,
      loadPrintedProducts: loadPrintedProducts,
    );
  }

  void initEntitys() {
    EnterpriseBuilder.entity = EntityFactory.makeEnterpriseData();
    commandNumber = faker.randomGenerator.integer(100);
    printedEntity = EntityFactory.makePrintedEntity();
    printedViewModel = PrintedViewModel.fromEntity(printedEntity);
  }

  void initMockSuccess() {
    loadPrintedProducts.mockLoadPrintedProducts(printedEntity);
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
  });
  group("Cancel product", () {
    test("Should emit correct values on success", () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.mainErrorStream, emits(null));

      await sut.cancelProduct(
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

      removePrintedProduct.mockError();

      await sut.cancelProduct(
        product: printedViewModel.Products[0],
        commandNumber: commandNumber,
        showSuccessMessage: () {},
        cartPresenter: cartPresenter,
        homePresenter: homePresenter,
      );
    });
    test("Should call removePrintedProduct with correct value", () async {
      final id = printedViewModel.Products[0].SaleRequestProductId;

      await sut.cancelProduct(
        product: printedViewModel.Products[0],
        commandNumber: commandNumber,
        showSuccessMessage: () {},
        cartPresenter: cartPresenter,
        homePresenter: homePresenter,
      );

      verify(() => removePrintedProduct.remove(id)).called(1);
    });
    test(
        "Should call insertServiceChargeProduct when contains product in list and dont is removing that",
        () async {
      await sut.loadProducts(commandNumber);

      EnterpriseBuilder.entity = EnterpriseEntity(
        pluServiceCharge: printedViewModel.Products[0]
            .ProductPriceLookUpCode, //putting the same PLU that call to remove product
        enterpriseName: EnterpriseBuilder.entity!.enterpriseName,
        url: EnterpriseBuilder.entity?.url,
        enterpriseId: EnterpriseBuilder.entity?.enterpriseId,
        concentradorUrl: EnterpriseBuilder.entity?.concentradorUrl,
        persistApp: EnterpriseBuilder.entity?.persistApp,
        urlCCS: EnterpriseBuilder.entity?.urlCCS,
        useCovenant: EnterpriseBuilder.entity?.useCovenant,
        enterpriseConcentradorParametersEntity:
            EnterpriseBuilder.entity?.enterpriseConcentradorParametersEntity,
        updateMenu: EnterpriseBuilder.entity?.updateMenu,
        updateConcentratorEnterpriseData:
            EnterpriseBuilder.entity?.updateConcentratorEnterpriseData,
        serviceChargePercentageOrValue:
            EnterpriseBuilder.entity?.serviceChargePercentageOrValue,
        serviceChargeType: EnterpriseBuilder.entity?.serviceChargeType,
        updateDevicesInformations:
            EnterpriseBuilder.entity?.updateDevicesInformations,
        updateEnterprise: EnterpriseBuilder.entity?.updateEnterprise,
        zoomImage: EnterpriseBuilder.entity?.zoomImage,
        pendingDevicesToUpdate:
            EnterpriseBuilder.entity?.pendingDevicesToUpdate,
        updatePendingDevices: EnterpriseBuilder.entity?.updatePendingDevices,
        waitDaysToPreloadImages:
            EnterpriseBuilder.entity?.waitDaysToPreloadImages,
        secondsPreloadingImages:
            EnterpriseBuilder.entity?.secondsPreloadingImages,
        internalCodeOnErpServiceCharge:
            EnterpriseBuilder.entity?.internalCodeOnErpServiceCharge,
      );

      await sut.cancelProduct(
        product: EntityFactory.makePrintedProductsViewModel()[0],
        commandNumber: commandNumber,
        showSuccessMessage: () {},
        cartPresenter: cartPresenter,
        homePresenter: homePresenter,
      );

      verify(() => cartPresenter.insertServiceChargeProduct(
            commandNumber.toString(),
          )).called(1);
    });
    test(
        "Should not call insertServiceChargeProduct if removed product is serviceCharge",
        () async {
      EnterpriseBuilder.entity = EnterpriseEntity(
        pluServiceCharge: printedViewModel.Products[0]
            .ProductPriceLookUpCode, //putting the same PLU that call to remove product
        enterpriseName: EnterpriseBuilder.entity!.enterpriseName,
        url: EnterpriseBuilder.entity?.url,
        enterpriseId: EnterpriseBuilder.entity?.enterpriseId,
        concentradorUrl: EnterpriseBuilder.entity?.concentradorUrl,
        persistApp: EnterpriseBuilder.entity?.persistApp,
        urlCCS: EnterpriseBuilder.entity?.urlCCS,
        useCovenant: EnterpriseBuilder.entity?.useCovenant,
        enterpriseConcentradorParametersEntity:
            EnterpriseBuilder.entity?.enterpriseConcentradorParametersEntity,
        updateMenu: EnterpriseBuilder.entity?.updateMenu,
        updateConcentratorEnterpriseData:
            EnterpriseBuilder.entity?.updateConcentratorEnterpriseData,
        serviceChargePercentageOrValue:
            EnterpriseBuilder.entity?.serviceChargePercentageOrValue,
        serviceChargeType: EnterpriseBuilder.entity?.serviceChargeType,
        updateDevicesInformations:
            EnterpriseBuilder.entity?.updateDevicesInformations,
        updateEnterprise: EnterpriseBuilder.entity?.updateEnterprise,
        zoomImage: EnterpriseBuilder.entity?.zoomImage,
        pendingDevicesToUpdate:
            EnterpriseBuilder.entity?.pendingDevicesToUpdate,
        updatePendingDevices: EnterpriseBuilder.entity?.updatePendingDevices,
        waitDaysToPreloadImages:
            EnterpriseBuilder.entity?.waitDaysToPreloadImages,
        secondsPreloadingImages:
            EnterpriseBuilder.entity?.secondsPreloadingImages,
        internalCodeOnErpServiceCharge:
            EnterpriseBuilder.entity?.internalCodeOnErpServiceCharge,
      );

      await sut.cancelProduct(
        product: printedViewModel.Products[0],
        commandNumber: commandNumber,
        showSuccessMessage: () {},
        cartPresenter: cartPresenter,
        homePresenter: homePresenter,
      );

      verifyNever(() => cartPresenter.insertServiceChargeProduct(
            commandNumber.toString(),
          ));
    });
  });
}
