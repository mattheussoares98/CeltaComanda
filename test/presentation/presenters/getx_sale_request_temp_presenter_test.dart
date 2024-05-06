import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:clean_celta_mobile/main/builders/builders.dart';
import 'package:clean_celta_mobile/presentation/presenters/presenters.dart';
import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:faker/faker.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../data/mocks/mocks.dart';
import '../../domain/mocks/mocks.dart';
import '../../ui/mocks/mocks.dart';

void main() {
  late GetxSaleRequestTempPresenter sut;
  late ExpansibleGroupsPresenterSpy expansibleGroupsPresenter;
  late PrintedProductsPresenterSpy printedProductsPresenter;
  late HomePresenterSpy homePresenter;

  late LoadSaleRequestTempSpy loadSaleRequestTemp;
  late UpdateProductQuantitySpy updateProductQuantity;
  late UpdateProductCommentSpy updateProductComment;
  late FinishSaleRequestTempSpy finishSaleRequestTemp;

  late SaleRequestTempEntity saleRequestTempEntity;
  late int saleRequestProductTempId;
  late String comments;

  void initUsecases() {
    loadSaleRequestTemp = LoadSaleRequestTempSpy();
    updateProductQuantity = UpdateProductQuantitySpy();
    updateProductComment = UpdateProductCommentSpy();
    finishSaleRequestTemp = FinishSaleRequestTempSpy();
  }

  void initPresenters() {
    expansibleGroupsPresenter = ExpansibleGroupsPresenterSpy();
    printedProductsPresenter = PrintedProductsPresenterSpy();
    homePresenter = HomePresenterSpy();

    sut = GetxSaleRequestTempPresenter(
      loadSaleRequestTemp: loadSaleRequestTemp,
      updateProductQuantity: updateProductQuantity,
      updateProductComment: updateProductComment,
      finishSaleRequestTemp: finishSaleRequestTemp,
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
  }

  setUp(() {
    initUsecases();
    initPresenters();
    initEntitys();
  });

  setUpAll(() {
    registerFallbackValue(PrintedProductsPresenterSpy());
    registerFallbackValue(SaleRequestTempPresenterSpy());
    registerFallbackValue(ExpansibleGroupsPresenterSpy());
    registerFallbackValue(
      EntityFactory.makeSaleRequestTempEntity(),
    );
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
    test("Should emits correct events on LoadSaleRequestTemp", () async {
      expectLater(sut.mainErrorStream, emits(null));

      await sut.load(homePresenter.commandNumberMock!);
    });

    test("Should emits correct events on error to LoadSaleRequestTemp",
        () async {
      loadSaleRequestTemp.mockError();

      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));

      await sut.load(homePresenter.commandNumberMock!);
    });

    test("Should call LoadSaleRequestTemp with correct values", () async {
      await sut.load(homePresenter.commandNumberMock!);

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
        expansibleGroupsPresenter: expansibleGroupsPresenter,
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
        expansibleGroupsPresenter: expansibleGroupsPresenter,
        printedProductsPresenter: printedProductsPresenter,
        saleRequestTempPresenter: sut,
        homePresenter: homePresenter,
      );
    });

    test("Should emit correct events on UpdateComment throws", () async {
      updateProductComment.mockUpdateProductCommentError();

      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.addComment]));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.updateComment(
        comments: comments,
        saleRequestProductTempId: saleRequestProductTempId,
        expansibleGroupsPresenter: expansibleGroupsPresenter,
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
        expansibleGroupsPresenter: expansibleGroupsPresenter,
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
        expansibleGroupsPresenter: expansibleGroupsPresenter,
        printedProductsPresenter: printedProductsPresenter,
        saleRequestTempPresenter: sut,
        homePresenter: homePresenter,
      );

      verify(() => homePresenter.load(
            commandNumber: homePresenter.commandNumberMock!,
            printedProductsPresenter: printedProductsPresenter,
            saleRequestTempPresenter: sut,
            expansibleGroupsPresenter: expansibleGroupsPresenter,
          )).called(1);
    });
  });

  group("FinishSaleRequestTemp", () {
    test("Should call FinishSaleRequestTemp with correct values", () async {
      await sut.finishSaleRequest(
        saleRequestTempEntity: saleRequestTempEntity,
        expansibleGroupsPresenter: expansibleGroupsPresenter,
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
        expansibleGroupsPresenter: expansibleGroupsPresenter,
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
        expansibleGroupsPresenter: expansibleGroupsPresenter,
        printedProductsPresenter: printedProductsPresenter,
        saleRequestTempPresenter: sut,
        homePresenter: homePresenter,
      );
    });

    test(
        "Should call ExpansibleGroupsPresenter.load on FinishSaleRequest success",
        () async {
      await sut.finishSaleRequest(
        saleRequestTempEntity: saleRequestTempEntity,
        expansibleGroupsPresenter: expansibleGroupsPresenter,
        printedProductsPresenter: printedProductsPresenter,
        saleRequestTempPresenter: sut,
        homePresenter: homePresenter,
      );

      verify(() => homePresenter.load(
            commandNumber: homePresenter.commandNumberMock!,
            printedProductsPresenter: printedProductsPresenter,
            saleRequestTempPresenter: sut,
            expansibleGroupsPresenter: expansibleGroupsPresenter,
          )).called(1);
    });
  });
}
