import '../../domain/entities/entities.dart';
import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';
import '../mixins/mixins.dart';

import 'package:get/get.dart';

class GetxCancelProductsPresenter extends GetxController
    with LoadingManager, UIErrorManager
    implements CancelProductsPresenter {
  final RemovePrintedProduct removePrintedProduct;
  final LoadPrintedProducts loadPrintedProducts;
  final UpdateSaleRequest updateSaleRequest; //TODO remove if dont works

  GetxCancelProductsPresenter({
    required this.removePrintedProduct,
    required this.loadPrintedProducts,
    required this.updateSaleRequest,
  });

  @override
  Future<void> cancelProduct({
    required PrintedProductsViewModel product,
    required int commandNumber,
    required void Function() showSuccessMessage,
    required CartPresenter cartPresenter,
    required HomePresenter homePresenter,
  }) async {
    isLoading = true;
    mainError = null;

    try {
      await removePrintedProduct.remove(product.SaleRequestProductId);
      await cartPresenter.updateIncrementValue(commandNumber.toString());

      await loadProducts(commandNumber);
      showSuccessMessage();
    } catch (e) {
      mainError = UIError.unexpected;
    } finally {
      isLoading = false;
    }
  }

  @override
  Future<void> loadProducts(int commandNumber) async {
    isLoading = true;
    mainError = null;

    try {
      PrintedEntity? printedProducts = await loadPrintedProducts.load(
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

  final _products = Rx<PrintedViewModel?>(null);
  @override
  Stream<PrintedViewModel?> get printedProducts => _products.stream;
  set products(PrintedViewModel? value) => _products.value = value;
}
