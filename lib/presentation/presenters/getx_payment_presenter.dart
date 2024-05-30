import 'package:get/get.dart';

import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/payment/payment.dart';
import '../../presentation/mixins/mixins.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/payment/payment_presenter.dart';

class GetxPaymentPresenter extends GetxController
    with LoadingManager, UIErrorManager
    implements PaymentPresenter {
  final Pay pay;

  GetxPaymentPresenter({
    required this.pay,
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
          longAmountValue: longAmountValue,
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
          longAmountValue: longAmountValue,
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
          longAmountValue: longAmountValue,
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
          longAmountValue: longAmountValue,
          portionQuantity: portionQuantity,
        ),
      );
    } catch (e) {
      mainError = UIError.unexpected;
    } finally {
      isLoading = false;
    }
  }
}
