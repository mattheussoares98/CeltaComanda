import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../domain/entities/entities.dart';
import '../../domain/usecases/usecases.dart';
import '../../main/builders/builders.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';

class GetxSaleRequestTempPresenter
    with ChangeNotifier
    implements SaleRequestTempPresenter {
  final LoadSaleRequestTemp loadSaleRequestTemp;
  final UpdateProductQuantity updateProductQuantity;
  final UpdateProductComment updateProductComment;
  final FinishSaleRequestTemp finishSaleRequestTemp;

  GetxSaleRequestTempPresenter({
    required this.loadSaleRequestTemp,
    required this.updateProductQuantity,
    required this.updateProductComment,
    required this.finishSaleRequestTemp,
  });

  SaleRequestTempViewModel? _saleRequestTemp;
  @override
  SaleRequestTempViewModel? get saleRequestTemp => _saleRequestTemp;
  set saleRequestTemp(SaleRequestTempViewModel? newValue) {
    _saleRequestTemp = newValue;
  }

  @override
  Future<void> load(String commandNumber) async {
    _saleRequestTemp = null;
    notifyListeners();
    mainError = null;

    try {
      SaleRequestTempEntity? saleRequestTemp = await loadSaleRequestTemp.load(
        url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
        enterpriseId: EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId!,
        commandNumber: commandNumber,
      );

      if (saleRequestTemp != null) {
        _saleRequestTemp = SaleRequestTempViewModel.fromEntity(saleRequestTemp);
        _saleRequestTemp!.Products
            .sort((a, b) => a.Product.Name.compareTo(b.Product.Name));
      }
      notifyListeners();
    } catch (e) {
      mainError = UIError.unexpected;
    }
  }

  @override
  void clear() {
    _saleRequestTemp = null;
    notifyListeners();
  }

  @override
  Future<void> addProductQuantity({
    required String url,
    required int saleRequestProductTempId,
    required String commandNumber,
  }) async {
    isLoading = true;
    mainError = null;

    try {
      await updateProductQuantity.add(
        url: url,
        saleRequestProductTempId: saleRequestProductTempId,
      );

      await load(commandNumber);
    } catch (e) {
      mainError = UIError.unexpected;
    } finally {
      isLoading = false;
    }
  }

  @override
  Future<void> subtractProductQuantity({
    required String url,
    required int saleRequestProductTempId,
    required int productQuantity,
    required String commandNumber,
  }) async {
    isLoading = true;
    mainError = null;

    try {
      if (productQuantity <= 1) {
        await updateProductQuantity.delete(
            url: url, saleRequestProductTempId: saleRequestProductTempId);
      } else {
        await updateProductQuantity.subtract(
          url: url,
          saleRequestProductTempId: saleRequestProductTempId,
        );
      }

      await load(commandNumber);
    } catch (e) {
      mainError = UIError.unexpected;
    } finally {
      isLoading = false;
    }
  }

  @override
  Future<void> updateComment({
    required String comments,
    required int saleRequestProductTempId,
    required ExpansibleGroupsPresenter expansibleGroupsPresenter,
    required PrintedProductsPresenter printedProductsPresenter,
    required SaleRequestTempPresenter saleRequestTempPresenter,
    required HomePresenter homePresenter,
  }) async {
    isLoading = true;
    mainError = null;

    try {
      await updateProductComment.update(
        url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
        saleRequestProductTempId: saleRequestProductTempId,
        comments: comments,
      );

      await homePresenter.load(
        commandNumber: homePresenter.commandNumber!,
        printedProductsPresenter: printedProductsPresenter,
        saleRequestTempPresenter: saleRequestTempPresenter,
        expansibleGroupsPresenter: expansibleGroupsPresenter,
      );

      updateIndexOfSelectedProduct(null);
    } catch (e) {
      mainError = UIError.addComment;
    } finally {
      isLoading = false;
    }
  }

  int? _indexOfSelectedProduct;
  @override
  int? get indexOfSelectedProduct => _indexOfSelectedProduct;

  @override
  void updateIndexOfSelectedProduct(int? index) {
    if (_indexOfSelectedProduct == index) {
      _indexOfSelectedProduct = null;
    } else {
      _indexOfSelectedProduct = index;
    }
    notifyListeners();
  }

  @override
  Future<void> finishSaleRequest({
    required SaleRequestTempEntity saleRequestTempEntity,
    required ExpansibleGroupsPresenter expansibleGroupsPresenter,
    required PrintedProductsPresenter printedProductsPresenter,
    required SaleRequestTempPresenter saleRequestTempPresenter,
    required HomePresenter homePresenter,
  }) async {
    isLoading = true;
    mainError = null;

    try {
      await finishSaleRequestTemp.finish(
        saleRequestTempEntity: saleRequestTempEntity,
        url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
      );

      await homePresenter.load(
        commandNumber: homePresenter.commandNumber!,
        printedProductsPresenter: printedProductsPresenter,
        saleRequestTempPresenter: saleRequestTempPresenter,
        expansibleGroupsPresenter: expansibleGroupsPresenter,
      );
    } catch (e) {
      mainError = UIError.unexpected;
    } finally {
      isLoading = false;
    }
  }

  final _isLoading = false.obs;
  @override
  Stream<bool> get isLoadingStream => _isLoading.stream;
  set isLoading(bool value) {
    _isLoading.value = value;
  }

  final _mainError = Rx<UIError?>(null);
  @override
  Stream<UIError?> get mainErrorStream => _mainError.stream;
  set mainError(UIError? value) => _mainError.value = value;
}
