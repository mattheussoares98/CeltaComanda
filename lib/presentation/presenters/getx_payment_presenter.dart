import 'package:clean_celta_mobile/domain/usecases/barcode/barcode.dart';
import 'package:get/get.dart';

import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/payment/payment.dart';
import '../../domain/usecases/printed_products/load_printed_products.dart';
import '../../presentation/mixins/mixins.dart';
import '../../main/builders/builders.dart';
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
  }) async {
    mainError = null;
    isLoading = true;
    try {
      if (!cartPresenter.isGeneratingVersionToRede) {
        writedCommandNumber = await barcodeScanner.read();
      }

      if (cartPresenter.isGeneratingVersionToRede &&
          writedCommandNumber == null) {
        throw DomainError.unexpected;
      }

      homePresenter.updateCommandNumber(writedCommandNumber);

      final printed = await loadPrintedProducts.load(
        url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
        enterpriseId: EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId!,
        commandNumber: writedCommandNumber!.toInt(),
      );

      if (printed == null) {
        throw DomainError.unexpected;
      }

      _totalAmountValue.value = printed.TotalLiquid;
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

  final _totalAmountValue = Rx<double?>(null);
  @override
  Stream<double?> get totalAmountValueStream => _totalAmountValue.stream;
}
