import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:clean_celta_mobile/presentation/presenters/presenters.dart';
import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:clean_celta_mobile/ui/pages/pages.dart';

import '../../data/mocks/mocks.dart';
import '../../domain/mocks/mocks.dart';

import 'package:flutter_test/flutter_test.dart';

import 'package:mocktail/mocktail.dart';

void main() {
  late GetxCommentsPresenter sut;

  late LoadExpansibleGroupsFromProductsCompleteSpy
      loadExpansibleGroupsFromProductsComplete;

  late List<ProductsViewModel> loadedProducts;
  late List<CommentsEntity>
      expansibleGroupFromProductComplete;
  late List<int> allInternalCodes;

  void initUseCases() {
    loadExpansibleGroupsFromProductsComplete =
        LoadExpansibleGroupsFromProductsCompleteSpy();
  }

  void initPresenters() {
    sut = GetxCommentsPresenter(
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

      await sut.loadComments(loadedProducts);
    });
    test("Should emit correct events on error", () async {
      loadExpansibleGroupsFromProductsComplete.mockError();

      expectLater(
          sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.loadComments(loadedProducts);
    });
    test("Should call loadExpansibleGroupsFromProductsComplete on loadComments",
        () async {
      await sut.loadComments(loadedProducts);

      verify(() => loadExpansibleGroupsFromProductsComplete.load(
            allInternalCodes,
          )).called(1);
    });

    test("Should call loadExpansibleGroupsFromProductsComplete on loadComments",
        () async {
      expect(sut.loadedComments, []);

      await sut.loadComments(loadedProducts);

      expect(
          sut.loadedComments,
          expansibleGroupFromProductComplete
              .map((e) => CommentViewModel
                      .fromExpansibleGroupsFromProductsCompleteEntity(
                    e,
                  ))
              .toList());
    });
  });
}
