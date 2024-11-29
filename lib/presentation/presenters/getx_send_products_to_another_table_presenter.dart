import '../../domain/entities/entities.dart';
import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
import '../../main/builders/builders.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';
import '../mixins/mixins.dart';

import 'package:get/get.dart';

class GetxSendProductsToAnotherTablePresenter extends GetxController
    with LoadingManager, UIErrorManager
    implements SendProductsToAnotherTablePresenter {
  final LoadPrintedProducts loadPrintedProducts;
  final ChangeSaleRequestPersonalizedCodeProducts
      changeSaleRequestPersonalizedCodeProducts;

  GetxSendProductsToAnotherTablePresenter({
    required this.loadPrintedProducts,
    required this.changeSaleRequestPersonalizedCodeProducts,
  });

  @override
  Future<void> loadProducts(int commandNumber) async {
    isLoading = true;
    mainError = null;

    try {
      clearAllSelectedsSaleRequestProductsIds();

      PrintedEntity? printedProducts = await loadPrintedProducts.load(
        url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
        enterpriseId: EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId!,
        commandNumber: commandNumber.toInt(),
      );

      products = null;
      if (printedProducts?.Products.isEmpty == false) {
        final printedViewModel = PrintedViewModel.fromEntity(printedProducts!);
        printedViewModel.Products.sort((a, b) =>
            DateTime.parse(a.DateHourOfCreation)
                .compareTo(DateTime.parse(b.DateHourOfCreation)));

        products = printedViewModel;
      }
    } catch (error) {
      switch (error) {
        case DomainError.commandNotAvailable:
          mainError = UIError.commandNotAvailable;
        default:
          mainError = UIError.unexpected;
      }
    } finally {
      isLoading = false;
    }
  }

  @override
  Future<void> sendProductsToAnotherTable({
    required int oldPersonalizedCode,
    required int newPersonalizedCode,
  }) async {
    isLoading = true;
    mainError = null;

    try {
      if (_selectedSaleRequestProductsIds.isEmpty) {
        throw DomainError.selectProducts;
      }
      await changeSaleRequestPersonalizedCodeProducts.change(
        oldPersonalizedCode: oldPersonalizedCode.toString().padLeft(3, "0"),
        newPersonalizedCode: newPersonalizedCode.toString().padLeft(3, "0"),
        saleRequestProductsIds: _selectedSaleRequestProductsIds,
      );

      await loadProducts(oldPersonalizedCode);
    } on DomainError catch (e) {
      switch (e) {
        case DomainError.selectProducts:
          mainError = UIError.selectProducts;
          break;
        default:
          mainError = UIError.unexpected;
      }
    } finally {
      isLoading = false;
    }
  }

  @override
  void updateProductIsSelected(int saleRequestProductId) {
    if (_selectedSaleRequestProductsIds.contains(saleRequestProductId)) {
      _selectedSaleRequestProductsIds.remove(saleRequestProductId);
    } else {
      _selectedSaleRequestProductsIds.add(saleRequestProductId);
    }
  }

  @override
  void clearAllSelectedsSaleRequestProductsIds() {
    _selectedSaleRequestProductsIds.clear();
  }

  final _products = Rx<PrintedViewModel?>(null);
  @override
  Stream<PrintedViewModel?> get printedProducts => _products.stream;
  set products(PrintedViewModel? value) => _products.value = value;

  final _selectedSaleRequestProductsIds = <int>[];
  @override
  List<int> get selectedsSaleRequestProductsIds =>
      [..._selectedSaleRequestProductsIds];
}
