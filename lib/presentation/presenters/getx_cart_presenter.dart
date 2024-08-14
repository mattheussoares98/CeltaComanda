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
    clear();

    try {
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

  int? _indexOfSelectedProduct;
  @override
  int? get indexOfSelectedProduct => _indexOfSelectedProduct;

  final _isLoading = false.obs;
  @override
  Stream<bool> get isLoadingStream => _isLoading.stream;
  set isLoading(bool value) => _isLoading.subject.add(value);

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
    double totalCartProductsPrice = 0;

    for (var products in _cartProducts) {
      totalCartProductsPrice += calculateProductPrice(products.Product) *
          products.Quantity.toDouble();
    }
    return totalCartProductsPrice
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

  @override
  CartProductEntity productWithSelectedsComments({
    required ExpansibleGroupFromProductPresenter
        expansibleGroupFromProductPresenter,
    required CartProductEntity product,
  }) {
    return CartProductEntity(
      Comments: expansibleGroupFromProductPresenter
          .getConcatenateSelectedCommentsAndObligatoryOptions(
              product.Product.InternalCodeOnERP!),
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
    required ExpansibleGroupFromProductPresenter
        expansibleGroupFromProductPresenter,
  }) async {
    isLoading = true;
    mainError = null;

    try {
      final productWithNewComment = productWithSelectedsComments(
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
        product: product,
      );

      final newCartList = [..._cartProducts];

      newCartList.add(CartProductsViewModel.fromEntity(productWithNewComment));

      await cartInformations.updateCartProducts(newCartList);
      _cartProducts = newCartList;

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
      notifyListeners();
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
        if (_cartProducts[index].Product.childsComposition != null) {
          _cartProducts[index].Product.childsComposition =
              _cartProducts[index].Product.childsComposition!.map((e) {
            double childQuantityInCombox = e.Quantity!.toDouble() /
                //o produto pode ter 2 quantidades informadas na montagem do combo, por isso eu faço esse cálculo de proporção pra somar sempre a quantidade correta
                _cartProducts[index].Quantity.toDouble();

            return ProductCompositionViewModel(
              ProductCompositionId: e.ProductCompositionId,
              EnterpriseId: e.EnterpriseId,
              InternalCodeOnERPCodeFather: e.InternalCodeOnERPCodeFather,
              InternalCodeOnERPCodeChild: e.InternalCodeOnERPCodeChild,
              PluChild: e.PluChild,
              ChildName: e.ChildName,
              Quantity:
                  (e.Quantity!.toDouble() - childQuantityInCombox).toString(),
              SalePrice: e.SalePrice,
              OfferPrice: e.OfferPrice,
              IncrementValue: e.IncrementValue,
              IsOptionalItem: e.IsOptionalItem,
              ProductOptions: e.ProductOptions,
              childs: e.childs,
              commentFather: e.commentFather,
              indexOfSelectedChild: e.indexOfSelectedChild,
            );
          }).toList();
        }

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
      if (_cartProducts[index].Product.childsComposition != null) {
        _cartProducts[index].Product.childsComposition =
            _cartProducts[index].Product.childsComposition!.map((e) {
          double childQuantityInCombox = e.Quantity!.toDouble() /
              //o produto pode ter 2 quantidades informadas na montagem do combo, por isso eu faço esse cálculo de proporção pra somar sempre a quantidade correta
              _cartProducts[index].Quantity.toDouble();

          return ProductCompositionViewModel(
            ProductCompositionId: e.ProductCompositionId,
            EnterpriseId: e.EnterpriseId,
            InternalCodeOnERPCodeFather: e.InternalCodeOnERPCodeFather,
            InternalCodeOnERPCodeChild: e.InternalCodeOnERPCodeChild,
            PluChild: e.PluChild,
            ChildName: e.ChildName,
            Quantity:
                (e.Quantity!.toDouble() + childQuantityInCombox).toString(),
            SalePrice: e.SalePrice,
            OfferPrice: e.OfferPrice,
            IncrementValue: e.IncrementValue,
            IsOptionalItem: e.IsOptionalItem,
            ProductOptions: e.ProductOptions,
            childs: e.childs,
            commentFather: e.commentFather,
            indexOfSelectedChild: e.indexOfSelectedChild,
          );
        }).toList();
      }

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
    required ExpansibleGroupFromProductPresenter
        expansibleGroupFromProductPresenter,
    String? commandNumber,
  }) async {
    isLoading = true;
    mainError = null;
    clear();
    addNewPrintRequestInFirebase();

    try {
      String informedCommandNumber;

      if (homePresenter.isFixedCommandNumber) {
        informedCommandNumber = homePresenter.commandNumber ?? "";
      } else {
        informedCommandNumber = await barcodeScanner.read();
      }

      homePresenter.updateCommandNumber(informedCommandNumber);

      SaleRequestTempEntity saleRequestTempResult =
          await loadSaleRequestTemp.load(
        url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
        enterpriseId: EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId!,
        commandNumber: informedCommandNumber,
      );

      _saleRequestTemp =
          SaleRequestTempViewModel.fromEntity(saleRequestTempResult);

      final products =
          _cartProducts.where((e) => e.Product.childsComposition == null).map(
        (element) {
          return UpdateSaleRequestTempProductEntity(
            ProductInternalCodeOnErp:
                element.toEntity().Product.InternalCodeOnERP!.toInt(),
            ProductPriceLookUpCode: element.toEntity().ProductPriceLookUpCode,
            Quantity: element.Quantity.toDouble(),
            SaleRequestTempId: _saleRequestTemp!.SaleRequestTempId.toInt(),
            TotalLiquid: element.TotalLiquid.toDouble(),
            Value: element.Value.toDouble(),
            Comments: element.Comments,
          );
        },
      ).toList();

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
      await cartInformations.clearCartProducts();
      await printedProductsPresenter.loadPrinted(homePresenter);

      _cartProducts.clear();

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

  @override
  List<UpdateSaleRequestTempProductEntity>
      convertProductsCompositionToUpdateSaleRequestTempProductEntity({
    required int saleRequestTempId,
  }) {
    List<UpdateSaleRequestTempProductEntity> productsEntitys = [];
    for (var product in _cartProducts) {
      if (product.Product.childsComposition == null) {
        continue;
      }
      for (var child in product.Product.childsComposition!) {
        if (child.indexOfSelectedChild == null) {
          continue;
        }

        final updateSaleRequestTempProductEntity =
            UpdateSaleRequestTempProductEntity(
          ProductInternalCodeOnErp:
              child.childs?.isEmpty == true || child.childs == null
                  ? child.InternalCodeOnERPCodeChild!.toInt()
                  : child.childs![child.indexOfSelectedChild!]
                      .InternalCodeOnERPCodeChild!
                      .toInt(),
          ProductPriceLookUpCode:
              child.childs?.isEmpty == true || child.childs == null
                  ? child.PluChild!
                  : child.childs![child.indexOfSelectedChild!].PluChild!,
          Quantity: child.Quantity!.toDouble(),
          SaleRequestTempId: saleRequestTempId,
          TotalLiquid: calculateProductCompositionTotalLiquid(child),
          Value: calculateProductCompositionPrice(child),
          Comments: child.commentFather,
        );

        productsEntitys.add(updateSaleRequestTempProductEntity);
      }
    }

    return productsEntitys;
  }

  @override
  double calculateProductCompositionIncrementValue(
      ProductCompositionViewModel product) {
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
  double calculateProductCompositionTotalLiquid(
      ProductCompositionViewModel product) {
    return calculateProductCompositionPrice(product) *
        product.Quantity.toString().toDouble();
  }

  @override
  double calculateProductCompositionPrice(ProductCompositionViewModel product) {
    if (product.IsOptionalItem == "true") {
      return calculateProductCompositionIncrementValue(product);
    } else if (product.OfferPrice.toString().toDouble() > 0) {
      return product.OfferPrice.toString().toDouble() +
          calculateProductCompositionIncrementValue(product);
    } else {
      return product.SalePrice.toString().toDouble() +
          calculateProductCompositionIncrementValue(product);
    }
  }

  @override
  Future<void> clearCart() async {
    isLoading = true;
    mainError = null;

    try {
      _cartProducts.clear();
      await cartInformations.clearCartProducts();
      notifyListeners();
    } catch (e) {
      mainError = UIError.unexpected;
    } finally {
      isLoading = false;
    }
  }

  @override
  double calculateProductPrice(ProductsViewModel product) {
    if (product.childsComposition == null) {
      return product.SaleRetailPraticed.toDouble();
    } else {
      double total = 0;
      for (var child in product.childsComposition!) {
        total += calculateProductCompositionPrice(child);
      }
      return total;
    }
  }
}
