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
    required CartPresenter cartPresenter,
    required HomePresenter homePresenter,
  }) async {
    isLoading = true;
    mainError = null;

    try {
      if (_selectedSaleRequestProductsIds.isEmpty) {
        throw DomainError.selectProducts;
      }

      final serviceChargeProduct = _printedProducts.value?.Products
          .firstWhereOrNull((e) =>
              e.ProductInternalCodeOnErp.toInt() ==
              EnterpriseBuilder.entity?.internalCodeOnErpServiceCharge);
      final saleRequestProductIdServiceCharge =
          _selectedSaleRequestProductsIds.firstWhereOrNull(
              (e) => e == serviceChargeProduct?.SaleRequestProductId.toInt());

      if (serviceChargeProduct != null &&
          saleRequestProductIdServiceCharge != null) {
        throw DomainError.cantSendServiceChargeProduct;
      }
      await changeSaleRequestPersonalizedCodeProducts.change(
        oldPersonalizedCode: oldPersonalizedCode.toString().padLeft(3, "0"),
        newPersonalizedCode: newPersonalizedCode.toString().padLeft(3, "0"),
        saleRequestProductsIds:
            _selectedSaleRequestProductsIds.map((e) => e).toList(),
      );

      if (_printedProducts.value?.Products.firstWhereOrNull((e) =>
              e.ProductPriceLookUpCode ==
              EnterpriseBuilder.entity!.pluServiceCharge) !=
          null) {
        await cartPresenter.insertServiceChargeProduct(
          oldPersonalizedCode.toString(),
        );
      }
      await cartPresenter.insertServiceChargeProduct(
        newPersonalizedCode.toString(),
      );
      await loadProducts(oldPersonalizedCode);
    } on DomainError catch (e) {
      switch (e) {
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

  final _printedProducts = Rx<PrintedViewModel?>(null);
  @override
  Stream<PrintedViewModel?> get printedProducts => _printedProducts.stream;
  set products(PrintedViewModel? value) => _printedProducts.value = value;

  final _selectedSaleRequestProductsIds = <int>[];
  @override
  List<int> get selectedsSaleRequestProductsIds =>
      _selectedSaleRequestProductsIds;

  @override
  void selectAllProducts() {
    if (_printedProducts.value == null) {
      return;
    }
    _selectedSaleRequestProductsIds.clear();
    _selectedSaleRequestProductsIds.addAll(_printedProducts.value!.Products
        .map((e) => e.SaleRequestProductId.toInt())
        .toList());

    final serviceChargeProduct = _printedProducts.value!.Products
        .firstWhereOrNull((e) =>
            e.ProductInternalCodeOnErp.toInt() ==
            EnterpriseBuilder.entity!.internalCodeOnErpServiceCharge);
    if (serviceChargeProduct != null &&
        _selectedSaleRequestProductsIds
            .contains(serviceChargeProduct.SaleRequestProductId.toInt())) {
      _selectedSaleRequestProductsIds.removeWhere(
          (e) => e == serviceChargeProduct.SaleRequestProductId.toInt());
    }
  }
}
