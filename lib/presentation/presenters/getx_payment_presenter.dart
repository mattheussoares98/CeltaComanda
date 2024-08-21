import 'package:get/get.dart';

import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
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
  Future<void> doPayment({
    required double longAmountValue,
    required int portionQuantity,
    required PaymentMode paymentMode,
  }) async {
    mainError = null;
    isLoading = true;
    try {
      await pay.pay(
        paymentMode:
            paymentMode, //no MainActivity faz o tratamento para se for o PaymentMode.credit não acionar a opção de credito parcelado, senão gera uma exceção
        params: PayParams(
          longAmountValue: (longAmountValue * 100).toInt(),
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
    required CartPresenter cartPresenter,
    required PrintedProductsPresenter printedProductsPresenter,
    required ExpansibleGroupFromProductPresenter
        expansibleGroupFromProductPresenter,
    required MenuPresenter menuPresenter,
  }) async {
    mainError = null;
    isLoading = true;
    try {
      await homePresenter.loadCommandData(
        menuPresenter: menuPresenter,
        printedProductsPresenter: printedProductsPresenter,
        cartPresenter: cartPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
        homePresenter: homePresenter,
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
