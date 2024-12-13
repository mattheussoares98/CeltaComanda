import 'package:get/get.dart';

import 'package:flutter/foundation.dart';

import '../../data/models/models.dart';
import '../../data/usecases/usecases.dart';
import '../../domain/entities/entities.dart';
import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
import '../../main/builders/builders.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';

class GetxCartPresenter with ChangeNotifier implements CartPresenter {
  final LoadSaleRequestTemp loadSaleRequestTemp;
  final FinishSaleRequestTempById finishSaleRequestTempById;
  final AddPrintRequest addPrintRequest;
  final LocalPrintRequest localPrintRequest;
  final UpdateSaleRequestTemp updateSaleRequestTemp;
  final ConfirmedCartProducts confirmedCartProducts;
  final CartInformations cartInformations;
  final BarcodeScanner barcodeScanner;
  final CommandInformations commandInformations;
  final LoadSaleRequest loadSaleRequest;
  final UpdateSaleRequest updateSaleRequest;
  final RemovePrintedProduct removePrintedProduct;
  final LoadPrintedProducts loadPrintedProducts;

  GetxCartPresenter({
    required this.loadSaleRequestTemp,
    required this.finishSaleRequestTempById,
    required this.addPrintRequest,
    required this.localPrintRequest,
    required this.updateSaleRequestTemp,
    required this.confirmedCartProducts,
    required this.cartInformations,
    required this.barcodeScanner,
    required this.commandInformations,
    required this.loadSaleRequest,
    required this.updateSaleRequest,
    required this.removePrintedProduct,
    required this.loadPrintedProducts,
  });

  @override
  Future<void> getSaleRequestTemp(String commandNumber) async {
    clear();

    try {
      SaleRequestTempEntity? saleRequestTemp = await loadSaleRequestTemp.load(
        url: EnterpriseBuilder.entity!.url!,
        enterpriseId: EnterpriseBuilder.entity!.enterpriseId!,
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
  String getTotalSaleRequestTempPrice(
      InsertProductPresenter insertProductPresenter) {
    double totalCartProductsPrice = 0;

    for (var products in _cartProducts) {
      final productPrice =
          insertProductPresenter.calculateProductTotalLiquid(products.Product);

      totalCartProductsPrice += productPrice;
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
    required String? writtedComment,
  }) {
    return CartProductEntity(
      Comments: writtedComment ??
          expansibleGroupFromProductPresenter
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
    required String? writtedComment,
  }) async {
    isLoading = true;
    mainError = null;

    try {
      final productWithNewComment = productWithSelectedsComments(
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
        product: product,
        writtedComment: writtedComment == "" ? null : writtedComment,
      );

      final newCartList = [..._cartProducts];

      final cartProductViewModel =
          CartProductsViewModel.fromEntity(productWithNewComment);

      cartProductViewModel.Product.productQuantity =
          productWithNewComment.Quantity;

      newCartList.add(cartProductViewModel);

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
              Schedule: e.Schedule,
            );
          }).toList();
        }

        final newQuantity = newCartList[index].Quantity.toDouble() - 1;
        newCartList[index].Product.productQuantity =
            newCartList[index].Product.productQuantity - 1;

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
      final maxQuantity =
          _cartProducts[index].Product.MaximumQuantityForSale?.toDouble() == 0
              ? 99.00
              : _cartProducts[index].Product.MaximumQuantityForSale!.toDouble();
      final newQuantity = _cartProducts[index].Quantity.toDouble() + 1;

      if (maxQuantity > 1 && newQuantity > maxQuantity) {
        throw DomainError.maximumQuantityAchieved;
      }

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
            Schedule: e.Schedule,
          );
        }).toList();
      }

      final newCartList = [..._cartProducts];

      newCartList[index].Product.productQuantity = newQuantity;

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
    } on DomainError catch (e) {
      switch (e) {
        case DomainError.maximumQuantityAchieved:
          mainError = UIError.maximumQuantityAchieved;
          break;
        default:
          mainError = UIError.unexpected;
          break;
      }
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
    required InsertProductPresenter insertProductPresenter,
  }) async {
    isLoading = true;
    mainError = null;
    clear();
    addNewPrintRequestInFirebase();

    try {
      if (homePresenter.commandEntity?.isFixedCommandNumber == false &&
          commandNumber == null) {
        throw DomainError.commandNumberObligatory;
      } else if (homePresenter.commandEntity?.isFixedCommandNumber == false &&
          commandNumber != null) {
        await homePresenter.updateCommandEntity(
          commandNumber: commandNumber,
          isFixedCommandNumber:
              homePresenter.commandEntity?.isFixedCommandNumber == true,
          pdv: homePresenter.commandEntity?.pdv,
        );
      }

      bool isValid = await commandInformations.isValidDatetime(
        commandNumber: homePresenter.commandEntity!.commandNumber!,
      );

      if (!isValid) {
        throw DomainError.blockedCommand;
      }

      SaleRequestTempEntity saleRequestTempResult =
          await loadSaleRequestTemp.load(
        url: EnterpriseBuilder.entity!.url!,
        enterpriseId: EnterpriseBuilder.entity!.enterpriseId!,
        commandNumber: homePresenter.commandEntity!.commandNumber!,
      );

      _saleRequestTemp =
          SaleRequestTempViewModel.fromEntity(saleRequestTempResult);

      final productsEntitys = getProductsEntitys(
        saleRequestTempId: _saleRequestTemp!.SaleRequestTempId.toInt(),
        insertProductPresenter: insertProductPresenter,
      );

      bool usingProductServiceCharge =
          EnterpriseBuilder.entity?.pluServiceCharge != null &&
              EnterpriseBuilder.entity?.internalCodeOnErpServiceCharge != null;

      final entity = UpdateSaleRequestTempEntity(
        DeliveryControl: _saleRequestTemp!.DeliveryControl.toInt(),
        EnterpriseId: _saleRequestTemp!.EnterpriseId.toInt(),
        PersonalizedCode: _saleRequestTemp!.PersonalizedCode,
        SaleRequestTempId: _saleRequestTemp!.SaleRequestTempId.toInt(),
        TotalLiquid: productsEntitys
            .where((e) => e.ProductIsFatherComposition == false)
            .fold(
                0.0,
                (previousValue, element) =>
                    element.TotalLiquid + previousValue),
        Products: productsEntitys,
        Comments: _saleRequestTemp?.Comments,
        SellerCode: _saleRequestTemp?.SellerCode,
        Peoples: _saleRequestTemp?.Peoples?.toInt(),
        CovenantCode: _saleRequestTemp?.CovenantCode?.toInt(),
        CustomerCode: _saleRequestTemp?.CustomerCode?.toInt(),
        IncrementValue: usingProductServiceCharge
            ? null
            : EnterpriseBuilder.entity?.serviceChargePercentageOrValue,
        IncrementType: usingProductServiceCharge ? null : 2,
      );

      bool? cartProductsAlreadyConfirmed =
          await confirmedCartProducts.isConfirmed();

      if (cartProductsAlreadyConfirmed != true) {
        await updateSaleRequestTemp.update(
          url: EnterpriseBuilder.entity!.url!,
          entity: entity,
        );
        await confirmedCartProducts.updateValue(true);
      }

      await finishSaleRequestTempById.finish(
        _saleRequestTemp!.SaleRequestTempId.toInt(),
      );

      await confirmedCartProducts.updateValue(false);
      await cartInformations.clearCartProducts();

      await insertServiceChargeProduct(
        commandNumber: homePresenter.commandEntity!.commandNumber!,
        homePresenter: homePresenter,
      );

      await printedProductsPresenter
          .loadPrinted(homePresenter.commandEntity!.commandNumber!);

      _cartProducts.clear();

      return true;
    } on DomainError catch (e) {
      switch (e) {
        case DomainError.commandAlreadyPaid:
          mainError = UIError.commandAlreadyPaid;
        case DomainError.commandNotAvailable:
          mainError = UIError.commandNotAvailable;
        case DomainError.commandNumberObligatory:
          mainError = UIError.commandNumberObligatory;
        case DomainError.barcodeNotRead:
          mainError = UIError.barcodeNotRead;
        case DomainError.blockedCommand:
          mainError = UIError.blockedCommand;
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
  List<UpdateSaleRequestTempProductEntity> getProductsEntitys({
    required int saleRequestTempId,
    required InsertProductPresenter insertProductPresenter,
  }) {
    List<UpdateSaleRequestTempProductEntity> productsEntitys = [];
    for (var product in _cartProducts) {
      int indexOfProductEntity = 0;
      late UpdateSaleRequestTempProductEntity productEntity;

      productEntity = UpdateSaleRequestTempProductEntity(
        ProductInternalCodeOnErp:
            product.toEntity().Product.InternalCodeOnERP!.toInt(),
        ProductPriceLookUpCode: product.toEntity().ProductPriceLookUpCode,
        Quantity: product.Quantity.toDouble(),
        SaleRequestTempId: saleRequestTempId,
        TotalLiquid: product.TotalLiquid.toDouble(),
        Value: product.Value.toDouble(),
        Comments: product.Comments,
        ProductIsFatherComposition: product.Product.childsComposition != null &&
            product.Product.childsComposition!.isNotEmpty,
        SaleRequestProductIdOfFather: null,
      );

      productsEntitys.add(productEntity);
      indexOfProductEntity += productsEntitys.lastIndexOf(productEntity);

      if (product.Product.childsComposition == null ||
          product.Product.childsComposition!.isEmpty) {
        continue;
      }
      for (var child in product.Product.childsComposition!) {
        if (child.indexOfSelectedChild == null) {
          continue;
        }

        final childEntity = UpdateSaleRequestTempProductEntity(
          ProductIsFatherComposition: false,
          SaleRequestProductIdOfFather: indexOfProductEntity,
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
          TotalLiquid: insertProductPresenter
              .calculateProductCompositionTotalLiquid(product: child),
          Value: insertProductPresenter.calculateProductCompositionPrice(child),
          Comments: child.commentFather,
        );

        productsEntitys.add(childEntity);
      }
    }

    return productsEntitys;
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
  double calculateServiceChargeValue(double totalLiquidSaleRequest) {
    if (EnterpriseBuilder.entity?.serviceChargePercentageOrValue == null) {
      return 0;
    } else {
      return totalLiquidSaleRequest *
          (EnterpriseBuilder.entity!.serviceChargePercentageOrValue! / 100);
    }
  }

  @override
  Future<void> insertServiceChargeProduct({
    required String commandNumber,
    required HomePresenter homePresenter,
  }) async {
    //não criei testes para essa função
    try {
      if (EnterpriseBuilder.entity?.serviceChargePercentageOrValue == null ||
          EnterpriseBuilder.entity?.pluServiceCharge == null ||
          EnterpriseBuilder.entity?.internalCodeOnErpServiceCharge == null) {
        return;
      }

      final printed = await loadPrintedProducts.load(
        url: EnterpriseBuilder
            .entity!.url!, //TODO remove parameters related to enterprise
        enterpriseId: EnterpriseBuilder.entity!.enterpriseId!,
        commandNumber: commandNumber.toInt(),
      );

      if (printed == null) {
        throw Exception();
      }

      final serviceChargeProduct = printed.Products.firstWhereOrNull((e) =>
          e.ProductInternalCodeOnErp.toInt() ==
          EnterpriseBuilder.entity?.internalCodeOnErpServiceCharge);

      if (serviceChargeProduct != null) {
        await removePrintedProduct
            .remove(serviceChargeProduct.SaleRequestProductId.toString());
      }

      double totalLiquid = 0;
      for (var product in printed.Products) {
        if (product.ProductInternalCodeOnErp.toInt() ==
            EnterpriseBuilder.entity?.internalCodeOnErpServiceCharge) {
          continue;
        }
        totalLiquid += product.TotalLiquid.toDouble();
      }
      final serviceChargeValue = totalLiquid *
          (EnterpriseBuilder.entity!.serviceChargePercentageOrValue! / 100);

      await updateSaleRequest.update(
        model: SaleRequestModel(
          CovenantCode: null,
          CustomerCode: null,
          TotalLiquid: totalLiquid + serviceChargeValue,
          Products: [
            SaleRequestProductModel(
              SaleMovementProductCompositionId: null,
              ProductPriceLookUpCode:
                  EnterpriseBuilder.entity!.pluServiceCharge,
              ProductInternalCodeOnErp:
                  EnterpriseBuilder.entity!.internalCodeOnErpServiceCharge!,
              QuantityString: "1",
              Comments: null,
              DateHourOfCreation: DateTime.now().toIso8601String(),
              IsCancelled: false,
              IsDelivered: true,
              IsPrinted: true,
              SaleRequestProductId: null,
              UserId: null,
              ProductionStatus: null,
              SaleRequestId: printed.SaleRequestId.toInt(),
              Value: serviceChargeValue,
              Quantity: 1,
              TotalLiquid: serviceChargeValue,
            ),
          ],
        ),
        commandNumberWithThreeNumbers:
            homePresenter.commandEntity!.commandNumber!,
        saleRequestId: printed.SaleRequestId.toInt(),
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
