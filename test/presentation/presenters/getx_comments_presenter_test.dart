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
  late List<ExpansibleGroupFromProductCompleteEntity>
      expansibleGroupFromProductComplete;
  late List<int> productsInternalCodeOfProductOnERP;

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
      EntityFactory.makeProductViewModel(),
      EntityFactory.makeProductViewModel(),
    ];

    expansibleGroupFromProductComplete =
        EntityFactory.makeExpansibleGroupFromProductCompleteEntity();

    productsInternalCodeOfProductOnERP = loadedProducts
        .map((e) => e.InternalCodeOnERP!.toInt())
        .toList();
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
            productsInternalCodeOfProductOnERP,
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
