import 'package:get/get.dart';

import 'package:flutter/foundation.dart';

import '../../data/usecases/usecases.dart';
import '../../domain/entities/entities.dart';
import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
import '../../main/builders/builders.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';

class GetxCartPresenter with ChangeNotifier implements CartPresenter {
  final LoadSaleRequestTemp loadSaleRequestTemp;
  final UpdateProductQuantity updateProductQuantity;
  final UpdateProductComment updateProductComment;
  final FinishSaleRequestTemp finishSaleRequestTemp;
  final TicketIsPermitted ticketIsPermitted;
  final AddPrintRequest addPrintRequest;
  final LocalPrintRequest localPrintRequest;
  final UpdateSaleRequestTemp updateSaleRequestTemp;
  final ConfirmedCartProducts confirmedCartProducts;
  final CartInformations cartInformations;
  final BarcodeScanner barcodeScanner;

  GetxCartPresenter({
    required this.loadSaleRequestTemp,
    required this.updateProductQuantity,
    required this.updateProductComment,
    required this.finishSaleRequestTemp,
    required this.ticketIsPermitted,
    required this.addPrintRequest,
    required this.localPrintRequest,
    required this.updateSaleRequestTemp,
    required this.confirmedCartProducts,
    required this.cartInformations,
    required this.barcodeScanner,
  });

  @override
  Future<void> loadSaleRequest(String commandNumber) async {
    isLoading = true;
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

      _saleRequestTemp = SaleRequestTempViewModel.fromEntity(saleRequestTemp);
      _saleRequestTemp!.Products
          .sort((a, b) => a.Product.Name.compareTo(b.Product.Name));
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
    required CartPresenter cartPresenter,
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
        cartPresenter: cartPresenter,
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
    required CartPresenter cartPresenter,
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
        cartPresenter: cartPresenter,
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
    required CartPresenter cartPresenter,
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
    return _cartProducts
        .fold(
            0.0,
            (previousValue, element) =>
                element.TotalLiquid.toDouble() + previousValue)
        .toString()
        .toBrazilianNumber()
        .addBrazilianCoin();
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

  List<CartProductsViewModel> _cartProducts = [];
  @override
  List<CartProductsViewModel> get cartProducts => _cartProducts;

  int _getIndexOfEqualProduct(CartProductEntity product) {
    return _cartProducts.indexWhere(
      (cartProduct) =>
          cartProduct.ProductPriceLookUpCode ==
              product.ProductPriceLookUpCode &&
          cartProduct.Comments == product.Comments &&
          cartProduct.Value == product.Value.toString(),
    );
  }

  CartProductsViewModel _getProductWithNewQuantity({
    required int indexOfEqualProduct,
    required CartProductEntity newProduct,
  }) {
    final productWithNewQuantity = CartProductsViewModel(
      Product: _cartProducts[indexOfEqualProduct].Product,
      Comments: _cartProducts[indexOfEqualProduct].Comments,
      TotalLiquid: (_cartProducts[indexOfEqualProduct].TotalLiquid.toDouble() +
              newProduct.TotalLiquid)
          .toString(),
      Quantity: (_cartProducts[indexOfEqualProduct].Quantity.toDouble() +
              newProduct.Quantity)
          .toString(),
      Value: newProduct.Value.toString(),
      ProductPriceLookUpCode: newProduct.ProductPriceLookUpCode,
    );

    return productWithNewQuantity;
  }

  @override
  Future<void> addProductInCart({
    required CartProductEntity product,
    required MenuPresenter menuPresenter,
  }) async {
    isLoading = true;
    mainError = null;

    try {
      final indexOfEqualProduct = _getIndexOfEqualProduct(product);
      final newCartList = [..._cartProducts];

      if (indexOfEqualProduct == -1) {
        newCartList.add(CartProductsViewModel.fromEntity(product));
      } else {
        newCartList[indexOfEqualProduct] = _getProductWithNewQuantity(
          indexOfEqualProduct: indexOfEqualProduct,
          newProduct: product,
        );
      }

      await cartInformations.updateCartProducts(newCartList);
      _cartProducts = newCartList;

      menuPresenter.updateSelectedProduct(null);
      notifyListeners();
    } catch (e) {
      mainError = UIError.unexpected;
    } finally {
      isLoading = false;
    }
  }

  @override
  Future<void> removeProductFromCart(int index) async {
    isLoading = true;
    mainError = null;
    try {
      final newCartList = [..._cartProducts];
      newCartList.removeAt(index);
      await cartInformations.updateCartProducts(newCartList);

      _cartProducts = newCartList;
    } catch (e) {
      mainError = UIError.unexpected;
    } finally {
      isLoading = false;
    }
  }

  @override
  Future<void> updateCommentOfProductCart({
    required int index,
    required String? newComment,
  }) async {
    if (newComment == _cartProducts[index].Comments) {
      return;
    }

    mainError = null;
    isLoading = true;
    final newCartList = [..._cartProducts];

    final productWithNewComment = CartProductsViewModel(
      Comments: newComment?.isEmpty == true ? null : newComment,
      Product: _cartProducts[index].Product,
      TotalLiquid: _cartProducts[index].TotalLiquid,
      Quantity: _cartProducts[index].Quantity,
      Value: _cartProducts[index].Value,
      ProductPriceLookUpCode: _cartProducts[index].ProductPriceLookUpCode,
    );
    newCartList[index] = productWithNewComment;

    try {
      await cartInformations.updateCartProducts(newCartList);

      _cartProducts = newCartList;
      _indexOfSelectedProduct = null;
    } catch (e) {
      mainError = UIError.unexpected;
    } finally {
      isLoading = false;
    }

    notifyListeners();
  }

  @override
  Future<void> reduceCartProductQuantity(int index) async {
    isLoading = true;
    mainError = null;

    final newCartList = [..._cartProducts];
    try {
      if (newCartList[index].Quantity.toDouble() <= 1) {
        newCartList.removeAt(index);
        await cartInformations.updateCartProducts(newCartList);
        _cartProducts = newCartList;
      } else {
        final newQuantity = newCartList[index].Quantity.toDouble() - 1;
        final productWithNewQuantity = CartProductsViewModel(
          Comments: newCartList[index].Comments,
          Product: newCartList[index].Product,
          TotalLiquid:
              (newCartList[index].Value.toDouble() * newQuantity).toString(),
          Quantity: newQuantity.toString(),
          Value: newCartList[index].Value,
          ProductPriceLookUpCode: newCartList[index].ProductPriceLookUpCode,
        );
        newCartList[index] = productWithNewQuantity;

        await cartInformations.updateCartProducts(newCartList);
        _cartProducts = newCartList;
      }
    } catch (e) {
      mainError = UIError.unexpected;
    } finally {
      isLoading = false;
    }

    notifyListeners();
  }

  @override
  Future<void> addCartProductQuantity(int index) async {
    isLoading = true;
    mainError = null;

    try {
      final newCartList = [..._cartProducts];

      final newQuantity = newCartList[index].Quantity.toDouble() + 1;

      final productWithNewQuantity = CartProductsViewModel(
        Comments: newCartList[index].Comments,
        Product: newCartList[index].Product,
        TotalLiquid:
            (newCartList[index].Value.toDouble() * newQuantity).toString(),
        Quantity: newQuantity.toString(),
        Value: newCartList[index].Value,
        ProductPriceLookUpCode: newCartList[index].ProductPriceLookUpCode,
      );

      newCartList[index] = productWithNewQuantity;

      await cartInformations.updateCartProducts(newCartList);
      _cartProducts = newCartList;
    } catch (e) {
      mainError = UIError.unexpected;
    } finally {
      isLoading = false;
    }

    notifyListeners();
  }

  @override
  Future<bool> saveProducts(
    PrintedProductsPresenter printedProductsPresenter,
  ) async {
    isLoading = true;
    mainError = null;
    clear();

    try {
      final commandNumber = await barcodeScanner.read();

      await ticketIsPermitted.verify(
        url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
        commandNumber: commandNumber,
      );

      SaleRequestTempEntity saleRequestTempResult =
          await loadSaleRequestTemp.load(
        url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
        enterpriseId: EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId!,
        commandNumber: commandNumber,
      );

      _saleRequestTemp =
          SaleRequestTempViewModel.fromEntity(saleRequestTempResult);

      final products = _cartProducts
          .map((element) => UpdateSaleRequestTempProductEntity(
                ProductInternalCodeOnErp:
                    element.toEntity().Product.InternalCodeOnERP!.toInt(),
                ProductPriceLookUpCode:
                    element.toEntity().ProductPriceLookUpCode,
                Quantity: element.Quantity.toDouble(),
                SaleRequestTempId: _saleRequestTemp!.SaleRequestTempId.toInt(),
                TotalLiquid: element.TotalLiquid.toDouble(),
                Value: element.Value.toDouble(),
                Comments: element.Comments,
              ))
          .toList();

      final entity = UpdateSaleRequestTempEntity(
        DeliveryControl: _saleRequestTemp!.DeliveryControl.toInt(),
        EnterpriseId: _saleRequestTemp!.EnterpriseId.toInt(),
        PersonalizedCode: _saleRequestTemp!.PersonalizedCode,
        SaleRequestTempId: _saleRequestTemp!.SaleRequestTempId.toInt(),
        TotalLiquid: products.fold(0.0,
            (previousValue, element) => element.TotalLiquid + previousValue),
        Products: products,
      );

      bool? cartProductsAlreadyConfirmed =
          await confirmedCartProducts.isConfirmed();

      if (cartProductsAlreadyConfirmed == false) {
        await updateSaleRequestTemp.update(
          url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
          entity: entity,
        );
        await confirmedCartProducts.updateValue(true);
      }

      saleRequestTempResult = await loadSaleRequestTemp.load(
        url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
        enterpriseId: EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId!,
        commandNumber: commandNumber,
      );

      await finishSaleRequestTemp.finish(
        saleRequestTempEntity: SaleRequestTempEntity(
          Products: saleRequestTempResult.Products,
          SaleRequestTempId: saleRequestTempResult.SaleRequestTempId,
          PersonalizedCode: saleRequestTempResult.PersonalizedCode,
          EnterpriseId: saleRequestTempResult.EnterpriseId,
          TotalLiquid: saleRequestTempResult.TotalLiquid,
          DeliveryControl: saleRequestTempResult.DeliveryControl,
          Comments: saleRequestTempResult.Comments,
        ),
        url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
      );

      await confirmedCartProducts.updateValue(false);
      _cartProducts.clear();
      await cartInformations.clearCartProducts();

      await printedProductsPresenter.loadPrinted(commandNumber);
      return true;
    } on DomainError catch (e) {
      switch (e) {
        case DomainError.commandNotAvailable:
          mainError = UIError.commandNotAvailable;
        case DomainError.barcodeNotRead:
          mainError = UIError.barcodeNotRead;
        default:
          mainError = UIError.unexpected;
      }
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  @override
  Future<void> getLocalCartProductsData() async {
    isLoading = true;
    mainError = null;
    try {
      final localCartProducts = await cartInformations.getCartProducts();
      if (localCartProducts != null) {
        _cartProducts = localCartProducts;
        notifyListeners();
      }
    } catch (e) {
      mainError = UIError.unexpected;
    } finally {
      isLoading = false;
    }
  }

  List<ConfirmedComboxViewModel> _confirmedCombox = [];
  @override
  List<ConfirmedComboxViewModel> get confirmedCombox => _confirmedCombox;

  @override
  Future<bool> addConfirmedCombox({
    required List<ProductCompositionViewModel> selectedChilds,
    required double totalPrice,
    required double quantity,
    required ProductsViewModel father,
  }) async {
    isLoading = true;
    mainError = null;

    try {
      _confirmedCombox.add(
        ConfirmedComboxViewModel(
          products: selectedChilds
              .map((element) => ProductCompositionViewModel(
                    Quantity:
                        (element.Quantity.toString().toDouble() * quantity)
                            .toString(),
                    ProductCompositionId: element.ProductCompositionId,
                    EnterpriseId: element.EnterpriseId,
                    InternalCodeOnERPCodeFather:
                        element.InternalCodeOnERPCodeFather,
                    InternalCodeOnERPCodeChild:
                        element.InternalCodeOnERPCodeChild,
                    PluChild: element.PluChild,
                    ChildName: element.ChildName,
                    SalePrice: element.SalePrice,
                    OfferPrice: element.OfferPrice,
                    IncrementValue: element.IncrementValue,
                    IsOptionalItem: element.IsOptionalItem,
                    ProductOptions: element.ProductOptions,
                  ))
              .toList(),
          father: father,
          totalPrice: totalPrice,
          quantity: quantity,
        ),
      );
      await cartInformations.updateConfirmedCombox(confirmedCombox);
      notifyListeners();
      return true;
    } catch (e) {
      mainError = UIError.unexpected;
      return false;
    } finally {
      isLoading = false;
    }
  }

  @override
  Future<void> getLocalConfirmedsCombox() async {
    isLoading = true;
    mainError = null;
    try {
      final localConfirmedCombox = await cartInformations.getConfirmedCombox();
      if (localConfirmedCombox != null) {
        _confirmedCombox = localConfirmedCombox;
        notifyListeners();
      }
    } catch (e) {
      mainError = UIError.unexpected;
    } finally {
      isLoading = false;
    }
  }
}
