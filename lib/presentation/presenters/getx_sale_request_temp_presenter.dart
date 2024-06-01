import 'package:get/get.dart';

import 'package:flutter/foundation.dart';

import '../../data/usecases/usecases.dart';
import '../../domain/entities/entities.dart';
import '../../domain/helpers/helpers.dart';
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
  final TicketIsPermitted ticketIsPermitted;
  final AddPrintRequest addPrintRequest;
  final LocalPrintRequest localPrintRequest;

  GetxSaleRequestTempPresenter({
    required this.loadSaleRequestTemp,
    required this.updateProductQuantity,
    required this.updateProductComment,
    required this.finishSaleRequestTemp,
    required this.ticketIsPermitted,
    required this.addPrintRequest,
    required this.localPrintRequest,
  });

  @override
  Future<void> loadSaleRequest(String commandNumber) async {
    clear();

    try {
      await ticketIsPermitted.verify(
        url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
        commandNumber: commandNumber,
      );

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
    } on DomainError catch (e) {
      switch (e) {
        case DomainError.commandNotAvailable:
          throw DomainError.commandNotAvailable;
        default:
          throw DomainError.unexpected;
      }
    } finally {
      notifyListeners();
    }
  }

  @override
  void clear() {
    _saleRequestTemp = null;
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

      await loadSaleRequest(commandNumber);
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

      await loadSaleRequest(commandNumber);
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
    required MenuPresenter menuPresenter,
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

      await loadCommandData(
        commandNumber: homePresenter.commandNumber!,
        printedProductsPresenter: printedProductsPresenter,
        saleRequestTempPresenter: saleRequestTempPresenter,
        menuPresenter: menuPresenter,
        homePresenter: homePresenter,
      );

      updateIndexOfSelectedProduct(null);
    } on DomainError catch (e) {
      switch (e) {
        case DomainError.addComment:
          mainError = UIError.addComment;
        default:
          mainError = UIError.unexpected;
      }
      mainError = UIError.addComment;
    } finally {
      isLoading = false;
    }
  }

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
    required MenuPresenter menuPresenter,
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

      await loadCommandData(
        commandNumber: homePresenter.commandNumber!,
        printedProductsPresenter: printedProductsPresenter,
        saleRequestTempPresenter: saleRequestTempPresenter,
        menuPresenter: menuPresenter,
        homePresenter: homePresenter,
      );

      await addNewPrintRequestInFirebase();
    } catch (e) {
      mainError = UIError.unexpected;
      await addNewPrintRequestInFirebase();
    } finally {
      isLoading = false;
    }
  }

  @override
  void updateLocalSaleRequestComment(String newComment) {
    _saleRequestTemp = SaleRequestTempViewModel(
      Products: _saleRequestTemp!.Products,
      PersonalizedCode: _saleRequestTemp!.PersonalizedCode,
      EnterpriseId: _saleRequestTemp!.EnterpriseId,
      TotalLiquid: _saleRequestTemp!.TotalLiquid,
      DeliveryControl: _saleRequestTemp!.DeliveryControl,
      SaleRequestTempId: _saleRequestTemp!.SaleRequestTempId,
      Comments: newComment,
    );
    notifyListeners();
  }

  @override
  Future<void> loadCommandData({
    required String commandNumber,
    required PrintedProductsPresenter printedProductsPresenter,
    required SaleRequestTempPresenter saleRequestTempPresenter,
    required MenuPresenter menuPresenter,
    required HomePresenter homePresenter,
  }) async {
    isLoading = true;
    mainError = null;
    homePresenter.updateCommandNumber(commandNumber);
    clear();
    printedProductsPresenter.clear();
    menuPresenter.clear();

    try {
      await loadSaleRequest(commandNumber);
      await menuPresenter.getGroupsAndProducts(commandNumber);
      await printedProductsPresenter.loadPrinted(commandNumber);
    } on DomainError catch (error) {
      homePresenter.updateCommandNumber(null);
      switch (error) {
        case DomainError.commandNotAvailable:
          mainError = UIError.commandNotAvailable;
          break;
        default:
          mainError = UIError.unexpected;
      }
    } finally {
      isLoading = false;
    }
  }

  int? _indexOfSelectedProduct;
  @override
  int? get indexOfSelectedProduct => _indexOfSelectedProduct;

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

  SaleRequestTempViewModel? _saleRequestTemp;
  @override
  SaleRequestTempViewModel? get saleRequestTemp => _saleRequestTemp;
  set saleRequestTemp(SaleRequestTempViewModel? newValue) {
    _saleRequestTemp = newValue;
  }

  @override
  String get totalSaleRequestTempPrice {
    if (saleRequestTemp?.Products != null) {
      return saleRequestTemp!.Products
          .fold(
              0.0,
              (previousValue, element) =>
                  element.toEntity().TotalLiquid + previousValue)
          .toStringAsFixed(2)
          .toBrazilianNumber();
    }
    return "0";
  }

  @override
  Future<void> addNewPrintRequestInFirebase() async {
    PrintRequestEntity newRequest = PrintRequestEntity(
      dates: [
        "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}",
      ],
      timesUsed: 1,
    );
    try {
      final localEntity = await localPrintRequest.getLocalPrintedEntity();

      if (localEntity != null) {
        newRequest = PrintRequestEntity(
          dates: [
            ...localEntity.dates,
            "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}",
          ],
          timesUsed: localEntity.timesUsed + 1,
        );
      }

      await addPrintRequest.add(newRequest);
      await localPrintRequest.clear();
    } catch (e) {
      await localPrintRequest.add(newRequest);
    }
  }

  final List<CartProductsViewModel> _cartProducts = [];
  @override
  List<CartProductsViewModel> get cartProducts => _cartProducts;

  @override
  void addProductInCart(CartProductEntity product) {
    _cartProducts.add(CartProductsViewModel.fromEntity(product));
    notifyListeners();
  }

  @override
  void removeProductFromCart(int index) {
    _cartProducts.removeAt(index);
  }

  @override
  void updateCommentOfProductCart({
    required int index,
    required String newComment,
  }) {
    final productWithNewComment = CartProductsViewModel(
      Comments: newComment,
      Product: _cartProducts[index].Product,
      TotalLiquid: _cartProducts[index].TotalLiquid,
      Quantity: _cartProducts[index].Quantity,
      Value: _cartProducts[index].Value,
      ProductPriceLookUpCode: _cartProducts[index].ProductPriceLookUpCode,
    );

    _cartProducts[index] = productWithNewComment;
    notifyListeners();
  }

  @override
  void reduceCartProductQuantity(int index) {
    if (_cartProducts[index].Quantity.toDouble() <= 1) {
      _cartProducts.removeAt(index);
    } else {
      final productWithNewQuantity = CartProductsViewModel(
        Comments: _cartProducts[index].Comments,
        Product: _cartProducts[index].Product,
        TotalLiquid: _cartProducts[index].TotalLiquid,
        Quantity: (_cartProducts[index].Quantity.toDouble() - 1).toString(),
        Value: _cartProducts[index].Value,
        ProductPriceLookUpCode: _cartProducts[index].ProductPriceLookUpCode,
      );
      _cartProducts[index] = productWithNewQuantity;
    }
    notifyListeners();
  }
}
