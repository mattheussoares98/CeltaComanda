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
    final totalCartProductsPrice = _cartProducts.fold(
        0.0,
        (previousValue, element) =>
            element.TotalLiquid.toDouble() + previousValue);

    double totalComboxPrice = 0;

    for (var combox in _confirmedCombox) {
      for (var product in combox.products) {
        totalComboxPrice += calculateProductTotalLiquid(product);
      }
    }
    return (totalCartProductsPrice + totalComboxPrice)
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
  CartProductEntity productWithSelectedsComments({
    required CommentsPresenter commentsPresenter,
    required CartProductEntity product,
  }) {
    return CartProductEntity(
      Comments: commentsPresenter.getConcatenateSelectedComments(),
      Product: product.Product,
      TotalLiquid: product.TotalLiquid,
      Quantity: product.Quantity,
      Value: product.Value,
      ProductPriceLookUpCode: product.ProductPriceLookUpCode,
    );
  }

  @override
  Future<void> addProductInCart({
    required CartProductEntity product,
    required MenuPresenter menuPresenter,
    required CommentsPresenter commentsPresenter,
  }) async {
    isLoading = true;
    mainError = null;

    try {
      final productWithNewComment = productWithSelectedsComments(
        commentsPresenter: commentsPresenter,
        product: product,
      );

      final indexOfEqualProduct =
          _getIndexOfEqualProduct(productWithNewComment);
      final newCartList = [..._cartProducts];

      if (indexOfEqualProduct == -1) {
        newCartList
            .add(CartProductsViewModel.fromEntity(productWithNewComment));
      } else {
        newCartList[indexOfEqualProduct] = _getProductWithNewQuantity(
          indexOfEqualProduct: indexOfEqualProduct,
          newProduct: product,
        );
      }

      await cartInformations.updateCartProducts(newCartList);
      _cartProducts = newCartList;

      menuPresenter.updateSelectedProduct(
        selectedProduct: null,
        commentsPresenter: commentsPresenter,
      );

      isLoading = false;
      animateProductGoingMenuToCart = true;
      await doAnimation();
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
  Future<bool> saveProducts({
    required PrintedProductsPresenter printedProductsPresenter,
    required int? tableNumber,
    required HomePresenter homePresenter,
    String? commandNumber,
  }) async {
    isLoading = true;
    mainError = null;
    clear();

    try {
      String informedCommandNumber;

      if (homePresenter.isFixedCommandNumber) {
        informedCommandNumber = homePresenter.commandNumber ?? "";
      } else {
        informedCommandNumber = await barcodeScanner.read();
      }

      homePresenter.updateCommandNumber(informedCommandNumber);

      await ticketIsPermitted.verify(
        url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
        commandNumber: informedCommandNumber,
      );

      SaleRequestTempEntity saleRequestTempResult =
          await loadSaleRequestTemp.load(
        url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
        enterpriseId: EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId!,
        commandNumber: informedCommandNumber,
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

      final selectedComboxProducts =
          convertProductsCompositionToUpdateSaleRequestTempProductEntity(
        saleRequestTempId: _saleRequestTemp!.SaleRequestTempId.toInt(),
      );

      products.addAll(selectedComboxProducts);

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
        commandNumber: informedCommandNumber,
      );

      await finishSaleRequestTemp.finish(
        saleRequestTempEntity: SaleRequestTempEntity(
          Products: saleRequestTempResult.Products,
          SaleRequestTempId: saleRequestTempResult.SaleRequestTempId,
          PersonalizedCode: saleRequestTempResult.PersonalizedCode,
          EnterpriseId: saleRequestTempResult.EnterpriseId,
          TotalLiquid: saleRequestTempResult.TotalLiquid,
          DeliveryControl: tableNumber ?? 0,
          Comments: saleRequestTempResult.Comments,
        ),
        url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
      );

      await confirmedCartProducts.updateValue(false);
      _cartProducts.clear();
      _confirmedCombox.clear();
      await cartInformations.clearCartProducts();
      await cartInformations.updateConfirmedCombox([]);

      await printedProductsPresenter.loadPrinted(informedCommandNumber);
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
    required ProductsViewModel selectedCombox,
  }) async {
    isLoading = true;
    mainError = null;

    try {
      _confirmedCombox.add(
        ConfirmedComboxViewModel(
          products: selectedChilds
              .where((selected) => selected.indexOfSelectedChild != null)
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
                    childs: element.childs,
                    commentFather: element.commentFather,
                    indexOfSelectedChild: element.indexOfSelectedChild,
                  ))
              .toList(),
          father: selectedCombox,
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

  @override
  Future<void> addComboxQuantity(int index) async {
    mainError = null;
    isLoading = true;

    try {
      final comboxWithNewQuantities = ConfirmedComboxViewModel(
        father: _confirmedCombox[index].father,
        quantity: _confirmedCombox[index].quantity + 1,
        totalPrice: _confirmedCombox[index].totalPrice,
        products: _confirmedCombox[index].products.map((element) {
          final productQuantity = (element.Quantity.toString().toDouble() /
              _confirmedCombox[index].quantity);
          final newQuantity =
              (element.Quantity.toString().toDouble() + productQuantity);

          return ProductCompositionViewModel(
            Quantity: newQuantity.toString(),
            ProductCompositionId: element.ProductCompositionId,
            EnterpriseId: element.EnterpriseId,
            InternalCodeOnERPCodeFather: element.InternalCodeOnERPCodeFather,
            InternalCodeOnERPCodeChild: element.InternalCodeOnERPCodeChild,
            PluChild: element.PluChild,
            ChildName: element.ChildName,
            SalePrice: element.SalePrice,
            OfferPrice: element.OfferPrice,
            IncrementValue: element.IncrementValue,
            IsOptionalItem: element.IsOptionalItem,
            ProductOptions: element.ProductOptions,
            childs: element.childs,
            commentFather: element.commentFather,
            indexOfSelectedChild: element.indexOfSelectedChild,
          );
        }).toList(),
      );

      _confirmedCombox[index] = comboxWithNewQuantities;
      await cartInformations.updateConfirmedCombox(confirmedCombox);
      notifyListeners();
    } catch (e) {
      mainError = UIError.unexpected;
    }

    isLoading = false;
  }

  @override
  Future<void> reduceComboxQuantity(int index) async {
    isLoading = true;
    mainError = null;
    try {
      if (_confirmedCombox[index].quantity <= 1) {
        _confirmedCombox.removeAt(index);
      } else {
        final comboxWithNewQuantities = ConfirmedComboxViewModel(
          father: _confirmedCombox[index].father,
          quantity: _confirmedCombox[index].quantity - 1,
          totalPrice: _confirmedCombox[index].totalPrice,
          products: _confirmedCombox[index].products.map((element) {
            final productQuantity = (element.Quantity.toString().toDouble() /
                _confirmedCombox[index].quantity);
            final newQuantity =
                (element.Quantity.toString().toDouble() - productQuantity);

            return ProductCompositionViewModel(
              Quantity: newQuantity.toString(),
              ProductCompositionId: element.ProductCompositionId,
              EnterpriseId: element.EnterpriseId,
              InternalCodeOnERPCodeFather: element.InternalCodeOnERPCodeFather,
              InternalCodeOnERPCodeChild: element.InternalCodeOnERPCodeChild,
              PluChild: element.PluChild,
              ChildName: element.ChildName,
              SalePrice: element.SalePrice,
              OfferPrice: element.OfferPrice,
              IncrementValue: element.IncrementValue,
              IsOptionalItem: element.IsOptionalItem,
              ProductOptions: element.ProductOptions,
              childs: element.childs,
              commentFather: element.commentFather,
              indexOfSelectedChild: element.indexOfSelectedChild,
            );
          }).toList(),
        );

        _confirmedCombox[index] = comboxWithNewQuantities;
      }
      await cartInformations.updateConfirmedCombox(confirmedCombox);
      notifyListeners();
    } catch (e) {
      mainError = UIError.unexpected;
    }
    isLoading = false;
  }

  int? _indexOfSelectedProductCombox;
  @override
  int? get indexOfSelectedProductCombox => _indexOfSelectedProductCombox;

  @override
  Future<void> updateCommentOfCombox({
    required int indexOfCombox,
    required int? indexOfProduct,
    required String? newComment,
  }) async {
    isLoading = true;
    mainError = null;
    try {
      if (indexOfProduct != null) {
        _confirmedCombox[indexOfCombox].products[indexOfProduct].commentFather =
            newComment;

        _indexOfSelectedProductCombox = null;
      }
      await cartInformations.updateConfirmedCombox(confirmedCombox);
      notifyListeners();
    } catch (e) {
      mainError = UIError.unexpected;
    } finally {
      isLoading = false;
    }
  }

  @override
  void updateIndexOfSelectedProductCombox(int? index) {
    if (_indexOfSelectedProductCombox == index) {
      _indexOfSelectedProductCombox = null;
    } else {
      _indexOfSelectedProductCombox = index;
    }
    notifyListeners();
  }

  @override
  List<UpdateSaleRequestTempProductEntity>
      convertProductsCompositionToUpdateSaleRequestTempProductEntity({
    required int saleRequestTempId,
  }) {
    List<UpdateSaleRequestTempProductEntity> productsEntitys = [];
    for (var combox in _confirmedCombox) {
      for (var product in combox.products) {
        if (product.indexOfSelectedChild == null) {
          continue;
        }

        ProductCompositionViewModel selectedChild;
        if (product.childs?.isEmpty == true) {
          selectedChild = product;
        } else {
          selectedChild = product.childs![product.indexOfSelectedChild!];
        }

        final updateSaleRequestTempProductEntity =
            UpdateSaleRequestTempProductEntity(
          ProductInternalCodeOnErp:
              selectedChild.InternalCodeOnERPCodeChild.toString().toInt(),
          ProductPriceLookUpCode: selectedChild.PluChild!,
          Quantity: selectedChild.Quantity!.toDouble(),
          SaleRequestTempId: saleRequestTempId,
          TotalLiquid: calculateProductTotalLiquid(product),
          Value: calculateProductPrice(product),
          Comments: product.commentFather,
        );

        productsEntitys.add(updateSaleRequestTempProductEntity);
      }
    }

    return productsEntitys;
  }

  @override
  double calculateIncrementValue(ProductCompositionViewModel product) {
    if (product.IncrementValue.toString().toDouble() > 0) {
      //se houver acréscimo no produto pai, retorna ele
      return product.IncrementValue.toString().toDouble();
    } else if (product.childs?.isEmpty == false &&
        product.indexOfSelectedChild != null) {
      //se houver filho selecionado e o filho tiver acréscimo, retorna o acréscimo do filho
      final selectedChild = product.childs![product.indexOfSelectedChild!];

      if (selectedChild.IncrementValue.toString().toDouble() > 0) {
        return selectedChild.IncrementValue.toString().toDouble();
      }
      return 0;
    } else {
      return 0;
    }
  }

  @override
  double calculateProductTotalLiquid(ProductCompositionViewModel product) {
    return calculateProductPrice(product) *
        product.Quantity.toString().toDouble();
  }

  @override
  double calculateProductPrice(ProductCompositionViewModel product) {
    if (product.IsOptionalItem == "true") {
      return calculateIncrementValue(product);
    } else if (product.OfferPrice.toString().toDouble() > 0) {
      return product.OfferPrice.toString().toDouble() +
          calculateIncrementValue(product);
    } else {
      return product.SalePrice.toString().toDouble() +
          calculateIncrementValue(product);
    }
  }

  @override
  Future<void> clearCart() async {
    isLoading = true;
    mainError = null;

    try {
      _cartProducts.clear();
      await cartInformations.clearCartProducts();
    } catch (e) {
      mainError = UIError.unexpected;
    } finally {
      isLoading = false;
    }
  }

  final _animateProductGoingMenuToCart = false.obs;
  set animateProductGoingMenuToCart(bool value) {
    _animateProductGoingMenuToCart.value = value;
  }

  @override
  Stream<bool> get animateProductGoingMenuToCartStream =>
      _animateProductGoingMenuToCart.stream;

  @override
  Future<void> doAnimation() async {
    animateProductGoingMenuToCart = true;
    await Future.delayed(
        Duration(
          milliseconds: AnimationManager
              .animateProductGoingMenuToCartDurationMilliseconds,
        ), () {
      animateProductGoingMenuToCart = false;
    });
  }
}
