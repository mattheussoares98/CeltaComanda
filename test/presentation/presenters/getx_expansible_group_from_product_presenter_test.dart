import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:clean_celta_mobile/presentation/presenters/presenters.dart';
import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:clean_celta_mobile/ui/pages/pages.dart';
import 'package:faker/faker.dart';

import '../../data/mocks/mocks.dart';
import '../../domain/mocks/mocks.dart';

import 'package:flutter_test/flutter_test.dart';

import 'package:mocktail/mocktail.dart';

void main() {
  late GetxExpansibleGroupFromProductPresenter sut;

  late LoadExpansibleGroupsFromProductsCompleteSpy
      loadExpansibleGroupsFromProductsComplete;

  late List<ProductsViewModel> loadedProducts;
  late List<CommentsEntity> expansibleGroupFromProductComplete;
  late List<int> allInternalCodes;

  void initUseCases() {
    loadExpansibleGroupsFromProductsComplete =
        LoadExpansibleGroupsFromProductsCompleteSpy();
  }

  void initPresenters() {
    sut = GetxExpansibleGroupFromProductPresenter(
      loadExpansibleGroupsFromProductsComplete:
          loadExpansibleGroupsFromProductsComplete,
    );
  }

  void initEntitys() {
    loadedProducts = [
      EntityFactory.makeProductViewModel(insertChildsComposition: true),
      EntityFactory.makeProductViewModel(insertChildsComposition: true),
    ];

    expansibleGroupFromProductComplete =
        EntityFactory.makeExpansibleGroupFromProductCompleteEntity(
      loadedProducts[0],
    );

    allInternalCodes = loadedProducts.expand((product) {
      var internalCodes = [product.InternalCodeOnERP!.toInt()];
      if (product.childsComposition != null) {
        internalCodes.addAll(product.childsComposition!
            .map((child) => child.InternalCodeOnERPCodeChild!.toInt()));
      }
      return internalCodes;
    }).toList();
  }

  void mockSuccess() {
    loadExpansibleGroupsFromProductsComplete.mockLoad(
      expansibleGroupFromProductComplete,
    );
  }

  setUp(() {
    initUseCases();
    initPresenters();
    initEntitys();
    mockSuccess();
  });

  setUpAll(() {
    registerFallbackValue(EntityFactory.makeEnterpriseData());
  });

  group("Load comments/expansibleGroupsFromProductsComplete", () {
    test("Should emit correct events on success", () async {
      expectLater(sut.mainErrorStream, emits(null));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.loadCommentsAndObligatoryOptions(loadedProducts);
    });
    test("Should emit correct events on error", () async {
      loadExpansibleGroupsFromProductsComplete.mockError();

      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.loadCommentsAndObligatoryOptions(loadedProducts);
    });
    test(
        "Should call loadExpansibleGroupsFromProductsComplete with correct values on loadComments",
        () async {
      await sut.loadCommentsAndObligatoryOptions(loadedProducts);

      verify(() => loadExpansibleGroupsFromProductsComplete.load(
            productsPackingInternalCodesOnErp: allInternalCodes,
            expansibleGroupType: 22,
          )).called(1);
      verify(() => loadExpansibleGroupsFromProductsComplete.load(
            productsPackingInternalCodesOnErp: allInternalCodes,
            expansibleGroupType: 23,
          )).called(1);
    });

    test(
        "Should update loadedComments correctly on loadCommentsAndObligatoryOptions",
        () async {
      expect(sut.loadedComments, []);

      await sut.loadCommentsAndObligatoryOptions(loadedProducts);

      expect(
          sut.loadedComments,
          expansibleGroupFromProductComplete
              .map((e) => ExpansibleGroupFromProductViewModel
                      .fromExpansibleGroupsFromProductsCompleteEntity(
                    e,
                  ))
              .toList());
    });
    test(
        "Should update loadedObligatoryOptions correctly on loadCommentsAndObligatoryOptions",
        () async {
      expect(sut.loadedObligatoryOptions, []);

      await sut.loadCommentsAndObligatoryOptions(loadedProducts);

      expect(
          sut.loadedObligatoryOptions,
          expansibleGroupFromProductComplete
              .map((e) => ExpansibleGroupFromProductViewModel
                      .fromExpansibleGroupsFromProductsCompleteEntity(
                    e,
                  ))
              .toList());
    });
  });

  group("Change is selected", () {
    test("Should update correctly comment is selected", () async {
      await sut.loadCommentsAndObligatoryOptions(loadedProducts);

      expect(sut.loadedComments[0].selected, false);
      sut.changeCommentIsSelected(sut.loadedComments[0]);
      expect(sut.loadedComments[0].selected, true);
    });
    test("Should update correctly obligatory option is selected", () async {
      await sut.loadCommentsAndObligatoryOptions(loadedProducts);

      expect(sut.loadedObligatoryOptions[0].selected, false);
      sut.changeObligatoryOptionIsSelected(sut.loadedObligatoryOptions[0]);
      expect(sut.loadedObligatoryOptions[0].selected, true);
    });
  });
  group("Unselect all data", () {
    test("Should unselect correctly when call sut.unselectAllComments",
        () async {
      await sut.loadCommentsAndObligatoryOptions(loadedProducts);
      sut.loadedComments[0].selected = true;

      sut.unselectAllComments();
      expect(sut.loadedComments[0].selected, false);
    });
    test(
        "Should unselect correctly when call sut.unselectAllOptionalObligatory",
        () async {
      await sut.loadCommentsAndObligatoryOptions(loadedProducts);
      sut.loadedObligatoryOptions[0].selected = true;

      sut.unselectAllOptionalObligatory();
      expect(sut.loadedObligatoryOptions[0].selected, false);
    });
  });

  group("Get concatenate selected values", () {
    test("Should return correctly concatenate values", () async {
      loadedProducts[0].childsComposition = null;
      await sut.loadCommentsAndObligatoryOptions([loadedProducts[0]]);
      loadExpansibleGroupsFromProductsComplete
          .mockLoad(expansibleGroupFromProductComplete);

      await sut.changeCommentIsSelected(sut.loadedComments[0]);
      expect(
        sut.getConcatenateSelectedCommentsAndObligatoryOptions(
          loadedProducts[0].InternalCodeOnERP!.toInt(),
        ),
        sut.loadedComments[0].GroupName,
      );
    });
  });

  group("Product has ExpansibleGroupFromProduct", () {
    test("Should return true if product has comment", () async {
      loadedProducts[0].childsComposition = null;
      await sut.loadCommentsAndObligatoryOptions([loadedProducts[0]]);

      expect(
        sut.productHasComment(
          product: loadedProducts[0],
          indexOfChild: -1,
        ),
        true,
      );
    });
    test("Should return false if product dont have comment", () async {
      loadExpansibleGroupsFromProductsComplete
          .mockLoad(EntityFactory.makeExpansibleGroupFromProductCompleteEntity(
        loadedProducts[1],
      ));

      await sut.loadCommentsAndObligatoryOptions([loadedProducts[0]]);

      expect(
        sut.productHasComment(
          product: loadedProducts[0],
          indexOfChild: 0,
        ),
        false,
      );
    });

    test("Should return true if product has obligatory option", () async {
      loadedProducts[0].childsComposition = null;
      await sut.loadCommentsAndObligatoryOptions([loadedProducts[0]]);

      expect(
        sut.productHasObligatoryOption(
          product: loadedProducts[0],
          indexOfChild: 0,
        ),
        true,
      );
    });
    test(
        "Should return false if childsComposition is null and indexOfFather is equal childsComposition.length",
        () async {
      await sut.loadCommentsAndObligatoryOptions([loadedProducts[0]]);

      expect(
        sut.productHasObligatoryOption(
          product: loadedProducts[0],
          indexOfChild: loadedProducts[0].childsComposition!.length,
        ),
        false,
      );
    });
    test(
        "Should return true if childs is not empty and indexofchild is selected",
        () async {
      loadExpansibleGroupsFromProductsComplete.mockLoad([
        CommentsEntity(
          ExpansibleGroupId: faker.randomGenerator.integer(10),
          ProductInternalCodeOnErp: loadedProducts[0]
              .childsComposition![0]
              .InternalCodeOnERPCodeChild!
              .toInt(),
          GroupName: "Any",
          ProductName: loadedProducts[0].childsComposition![0].ChildName!,
        ),
      ]);

      await sut.loadCommentsAndObligatoryOptions([loadedProducts[0]]);

      expect(
        sut.productHasObligatoryOption(
          product: loadedProducts[0],
          indexOfChild: 0,
        ),
        true,
      );
    });
    test("Should return false if product dont have obligatory option",
        () async {
      loadExpansibleGroupsFromProductsComplete
          .mockLoad(EntityFactory.makeExpansibleGroupFromProductCompleteEntity(
        loadedProducts[1],
      ));

      await sut.loadCommentsAndObligatoryOptions([loadedProducts[0]]);
      loadExpansibleGroupsFromProductsComplete
          .mockLoad(expansibleGroupFromProductComplete);

      expect(
        sut.productHasObligatoryOption(
          product: loadedProducts[0],
          indexOfChild: 0,
        ),
        false,
      );
    });
  });
}
