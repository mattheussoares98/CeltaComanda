import 'package:clean_celta_mobile/domain/usecases/barcode/barcode.dart';
import 'package:get/get.dart';

import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/payment/payment.dart';
import '../../domain/usecases/printed_products/load_printed_products.dart';
import '../../presentation/mixins/mixins.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';

class GetxPaymentPresenter extends GetxController
    with LoadingManager, UIErrorManager
    implements PaymentPresenter {
  final Pay pay;
  final LoadPrintedProducts loadPrintedProducts;
  final BarcodeScanner barcodeScanner;

  GetxPaymentPresenter({
    required this.pay,
    required this.loadPrintedProducts,
    required this.barcodeScanner,
  });

  @override
  Future<void> payWithCredit({
    required double longAmountValue,
    required int portionQuantity,
  }) async {
    mainError = null;
    isLoading = true;
    try {
      await pay.pay(
        paymentMode: PaymentMode
            .credit, //no MainActivity faz o tratamento para se for o PaymentMode.credit não acionar a opção de credito parcelado, senão gera uma exceção
        params: PayParams(
          longAmountValue: longAmountValue.toString().toInt(true),
          portionQuantity: portionQuantity,
        ),
      );
    } catch (e) {
      mainError = UIError.unexpected;
    } finally {
      isLoading = false;
    }
  }

  @override
  Future<void> payWithCreditPortion({
    required double longAmountValue,
    required int portionQuantity,
  }) async {
    mainError = null;
    isLoading = true;
    try {
      await pay.pay(
        paymentMode: PaymentMode.creditPortion,
        params: PayParams(
          longAmountValue: longAmountValue.toString().toInt(true),
          portionQuantity: portionQuantity,
        ),
      );
    } catch (e) {
      mainError = UIError.unexpected;
    } finally {
      isLoading = false;
    }
  }

  @override
  Future<void> payWithDebit({
    required double longAmountValue,
    required int portionQuantity,
  }) async {
    mainError = null;
    isLoading = true;
    try {
      await pay.pay(
        paymentMode: PaymentMode.debit,
        params: PayParams(
          longAmountValue: longAmountValue.toString().toInt(true),
          portionQuantity: portionQuantity,
        ),
      );
    } catch (e) {
      mainError = UIError.unexpected;
    } finally {
      isLoading = false;
    }
  }

  @override
  Future<void> payWithPix({
    required double longAmountValue,
    required int portionQuantity,
  }) async {
    mainError = null;
    isLoading = true;
    try {
      await pay.pay(
        paymentMode: PaymentMode.pix,
        params: PayParams(
          longAmountValue: longAmountValue.toString().toInt(true),
          portionQuantity: portionQuantity,
        ),
      );
    } catch (e) {
      mainError = UIError.unexpected;
    } finally {
      isLoading = false;
    }
  }

  @override
  Future<void> getTotalValue({
    required HomePresenter homePresenter,
    required String? writedCommandNumber,
    required CartPresenter cartPresenter,
    required PrintedProductsPresenter printedProductsPresenter,
    required MenuPresenter menuPresenter,
  }) async {
    mainError = null;
    isLoading = true;
    try {
      if (cartPresenter.isGeneratingVersionToRede &&
          writedCommandNumber == null) {
        throw DomainError.unexpected;
      } else if (cartPresenter.isGeneratingVersionToRede) {
        homePresenter.updateCommandNumber(writedCommandNumber);
      }

      await printedProductsPresenter.loadCommandData(
        printedProductsPresenter: printedProductsPresenter,
        cartPresenter: cartPresenter,
        menuPresenter: menuPresenter,
        homePresenter: homePresenter,
        clearPermissionToCancelProducts: false,
        isRemovingProduct: false,
        commandNumber: homePresenter.commandNumber ?? "",
      );
    } on DomainError catch (e) {
      switch (e) {
        case DomainError.barcodeNotRead:
          mainError = UIError.barcodeNotRead;
          break;
        default:
          mainError = UIError.unexpected;
      }
    } finally {
      isLoading = false;
    }
  }
}
