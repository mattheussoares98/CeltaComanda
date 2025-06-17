import '../../data/models/models.dart';
import '../../domain/entities/entities.dart';
import '../../domain/usecases/usecases.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';
import '../mixins/mixins.dart';

import 'package:get/get.dart';

class GetxCancelProductsPresenter extends GetxController
    with LoadingManager, UIErrorManager, ErrorHandling
    implements CancelProductsPresenter {
  final RemovePrintedProduct removePrintedProduct;
  final LoadPrintedProducts loadPrintedProducts;
  final UpdateSaleRequest updateSaleRequest;

  GetxCancelProductsPresenter({
    required this.removePrintedProduct,
    required this.loadPrintedProducts,
    required this.updateSaleRequest,
  });

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
            DateTime.parse(a.DateHourOfCreation!)
                .compareTo(DateTime.parse(b.DateHourOfCreation!)));

        products = printedViewModel;
      }
    } catch (e) {
      mainError = getUIError(e);
    } finally {
      isLoading = false;
    }
  }

  final _products = Rx<PrintedViewModel?>(null);
  @override
  Stream<PrintedViewModel?> get printedProducts => _products.stream;
  set products(PrintedViewModel? value) => _products.value = value;

  @override
  Future<void> cancelProduct({
    required PrintedProductsViewModel product,
    required PrintedModel printedModel,
    required int commandNumber,
    required void Function() showSuccessMessage,
    required CartPresenter cartPresenter,
    required HomePresenter homePresenter,
    required int UserIdOfCancellation,
  }) async {
    isLoading = true;
    mainError = null;

    try {
      final model = SaleRequestModel(
        Products: printedModel.Products.map(
          (e) {
            final bool isSameProduct =
                product.SaleRequestProductId?.toInt() == e.SaleRequestProductId;

            return SaleRequestProductModel.fromEntity(
              SaleRequestProductEntity(
                ProductIsFatherComposition: e.ProductIsFatherComposition,
                IsCancelled: isSameProduct == true ? true : e.IsCancelled,
                UserIdOfCancellation: isSameProduct
                    ? UserIdOfCancellation
                    : e.UserIdOfCancellation,
                Product: e.Product,
                SaleMovementProductCompositionId:
                    e.SaleMovementProductCompositionId,
                ProductPriceLookUpCode: e.ProductPriceLookUpCode,
                QuantityString: e.QuantityString,
                Comments: e.Comments,
                DateHourOfCreation: e.DateHourOfCreation,
                IsDelivered: e.IsDelivered,
                IsPrinted: e.IsPrinted,
                SaleRequestProductId: e.SaleRequestProductId,
                UserId: e.UserId,
                ProductionStatus: e.ProductionStatus,
                ProductInternalCodeOnErp: e.ProductInternalCodeOnErp,
                SaleRequestId: e.SaleRequestId,
                Value: e.Value,
                Quantity: e.Quantity,
                TotalLiquid: e.TotalLiquid,
              ),
            );
          },
        ).toList(),
        DateOfCreation: printedModel.DateOfCreation,
        DateHourOfCreation: printedModel.DateHourOfCreation,
        RequestType: printedModel.RequestType,
        SellerCode: printedModel.SellerCode,
        FlagStatus: printedModel.FlagStatus,
        Comments: printedModel.Comments,
        PersonalizedCode: printedModel.PersonalizedCode,
        IsCancelled: printedModel.IsCancelled,
        IsUsing: printedModel.IsUsing,
        TotalLiquid: printedModel.TotalLiquid,
        CovenantCode: printedModel.CovenantCode,
        CustomerCode: printedModel.CustomerCode,
        EnterpriseId: printedModel.EnterpriseId,
        Peoples: printedModel.Peoples,
        FlagOrigin: printedModel.FlagOrigin,
        DeliveryControl: printedModel.DeliveryControl,
        SaleRequestId: printedModel.SaleRequestId,
        IncrementValue: printedModel.IncrementValue,
        IncrementType: printedModel.IncrementType,
        PlaceId: printedModel.PlaceId,
      );

      // await removePrintedProduct.remove(product.SaleRequestProductId!);
      await updateSaleRequest.update(
        commandNumber: commandNumber.toString(),
        saleRequestId: printedModel.SaleRequestId!,
        model: model,
      );

      if (printedModel.IncrementType == 1) {
        await cartPresenter.updateIncrementValue(commandNumber.toString());
      }

      await loadProducts(commandNumber);
      showSuccessMessage();
    } catch (e) {
      mainError = getUIError(e);
    } finally {
      isLoading = false;
    }
  }
}
