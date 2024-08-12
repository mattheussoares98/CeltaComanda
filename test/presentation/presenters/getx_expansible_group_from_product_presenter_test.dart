import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:clean_celta_mobile/presentation/presenters/presenters.dart';
import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:clean_celta_mobile/ui/pages/pages.dart';

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
        EntityFactory.makeExpansibleGroupFromProductCompleteEntity();

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
      await sut.loadCommentsAndObligatoryOptions(loadedProducts);
      expect(true, false); //arrumar esse teste
    });
  });
}
