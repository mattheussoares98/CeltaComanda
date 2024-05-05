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

  late LoadSaleRequestTempSpy loadSaleRequestTemp;
  late UpdateProductQuantitySpy updateProductQuantity;
  late UpdateProductCommentSpy updateProductComment;
  late FinishSaleRequestTempSpy finishSaleRequestTemp;

  late String commandNumber;
  late int saleRequestProductTempId;
  late String comments;

  setUp(() {
    loadSaleRequestTemp = LoadSaleRequestTempSpy();
    updateProductQuantity = UpdateProductQuantitySpy();
    updateProductComment = UpdateProductCommentSpy();
    finishSaleRequestTemp = FinishSaleRequestTempSpy();

    expansibleGroupsPresenter = ExpansibleGroupsPresenterSpy();
    printedProductsPresenter = PrintedProductsPresenterSpy();

    sut = GetxSaleRequestTempPresenter(
      loadSaleRequestTemp: loadSaleRequestTemp,
      updateProductQuantity: updateProductQuantity,
      updateProductComment: updateProductComment,
      finishSaleRequestTemp: finishSaleRequestTemp,
    );

    EnterpriseDataBuilder.enterpriseDataEntity =
        EntityFactory.makeEnterpriseData();
    saleRequestProductTempId = faker.randomGenerator.integer(3);
    commandNumber = faker.randomGenerator.integer(3).toString();
    comments = faker.randomGenerator.string(10);
  });

  setUpAll(() {
    registerFallbackValue(PrintedProductsPresenterSpy());
    registerFallbackValue(SaleRequestTempPresenterSpy());
  });

  group("AddProductQuantity group", () {
    test("Should call AddProductQuantity with correct values", () async {
      await sut.addProductQuantity(
        url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
        saleRequestProductTempId: saleRequestProductTempId,
        commandNumber: commandNumber,
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
        commandNumber: commandNumber,
      );
    });

    test("Should emits correct events on AddtractProductQuantity", () async {
      expectLater(sut.mainErrorStream, emits(null));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.addProductQuantity(
        url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
        saleRequestProductTempId: saleRequestProductTempId,
        commandNumber: commandNumber,
      );
    });
  });
  group("SubtractProductQuantity group", () {
    test("Should call SubtractProductQuantity with correct values", () async {
      await sut.subtractProductQuantity(
        url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
        saleRequestProductTempId: saleRequestProductTempId,
        productQuantity: 10,
        commandNumber: commandNumber,
      );

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
        commandNumber: commandNumber,
      );
    });

    test("Should emits correct events on SubtractProductQuantity", () async {
      expectLater(sut.mainErrorStream, emits(null));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.subtractProductQuantity(
        url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
        saleRequestProductTempId: saleRequestProductTempId,
        productQuantity: 10,
        commandNumber: commandNumber,
      );
    });

    test("Should call delete product if productQuantity is less than 1",
        () async {
      await sut.subtractProductQuantity(
        url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
        saleRequestProductTempId: saleRequestProductTempId,
        productQuantity: 1,
        commandNumber: commandNumber,
      );

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
        commandNumber: commandNumber,
      );

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
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.load(commandNumber);
    });

    test("Should emits correct events on error to LoadSaleRequestTemp",
        () async {
      loadSaleRequestTemp.mockError();

      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.load(commandNumber);
    });

    test("Should call LoadSaleRequestTemp with correct values", () async {
      await sut.load(commandNumber);

      verify(() => loadSaleRequestTemp.load(
            url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
            enterpriseId:
                EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId!,
            commandNumber: commandNumber,
          )).called(1);
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
      );
      expect(sut.indexOfSelectedProduct, null);
    });

    test("Should call expansibleGroups.load when UpdateComment", () async {
      expansibleGroupsPresenter.commandNumberMock = commandNumber;
      await sut.updateComment(
        comments: comments,
        saleRequestProductTempId: saleRequestProductTempId,
        expansibleGroupsPresenter: expansibleGroupsPresenter,
        printedProductsPresenter: printedProductsPresenter,
        saleRequestTempPresenter: sut,
      );

      verify(() => expansibleGroupsPresenter.load(
            commandNumber: expansibleGroupsPresenter.commandNumberMock!,
            printedProductsPresenter: printedProductsPresenter,
            saleRequestTempPresenter: sut,
          )).called(1);
    });
  });
}
