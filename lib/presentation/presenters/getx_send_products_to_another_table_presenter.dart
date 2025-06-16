import '../../domain/entities/entities.dart';
import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
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
        commandNumber: commandNumber.toInt(),
      );

      products = null;
      if (printedProducts?.Products.isEmpty == false) {
        final printedViewModel = PrintedViewModel.fromEntity(printedProducts!);
        printedViewModel.Products.sort((a, b) =>
            DateTime.parse(a.DateHourOfCreation!)
                .compareTo(DateTime.parse(b.DateHourOfCreation!)));

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
    required CartPresenter cartPresenter,
    required HomePresenter homePresenter,
  }) async {
    isLoading = true;
    mainError = null;

    try {
      if (_selectedProducts.isEmpty) {
        throw DomainError.selectProducts;
      } else if (oldPersonalizedCode == newPersonalizedCode) {
        throw DomainError.sameCommand;
      }

      await changeSaleRequestPersonalizedCodeProducts.change(
        oldPersonalizedCode: oldPersonalizedCode.toString().padLeft(3, "0"),
        newPersonalizedCode: newPersonalizedCode.toString().padLeft(3, "0"),
        saleRequestProductsIds: _selectedProducts
            .map((e) => e.SaleRequestProductId!.toInt())
            .toList(),
      );

      await cartPresenter.updateIncrementValue(
        oldPersonalizedCode.toString().padLeft(3, "0"),
      );
      await cartPresenter.updateIncrementValue(
        newPersonalizedCode.toString().padLeft(3, "0"),
      );
      await loadProducts(oldPersonalizedCode);
    } on DomainError catch (e) {
      switch (e) {
        case DomainError.sameCommand:
          mainError = UIError.sameCommand;
          break;
        case DomainError.cantSendServiceChargeProduct:
          mainError = UIError.cantSendServiceChargeProduct;
          break;
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
  void updateProductIsSelected(int index) {
    final product = _printedProducts.value?.Products[index];

    if (_selectedProducts.contains(product)) {
      _selectedProducts.remove(product);
    } else {
      _selectedProducts.add(product!);
    }
  }

  @override
  void clearAllSelectedsSaleRequestProductsIds() {
    _selectedProducts.clear();
  }

  final _printedProducts = Rx<PrintedViewModel?>(null);
  @override
  Stream<PrintedViewModel?> get printedProducts => _printedProducts.stream;
  set products(PrintedViewModel? value) => _printedProducts.value = value;

  final _selectedProducts = <PrintedProductsViewModel>[];
  @override
  List<PrintedProductsViewModel>? get selectedProducts => _selectedProducts;

  @override
  void selectAllProducts() {
    if (_printedProducts.value == null) {
      return;
    }
    _selectedProducts.clear();
    _selectedProducts.addAll(_printedProducts.value!.Products
        .where((e) => e.IsCancelled == "false")
        .toList());
  }
}
