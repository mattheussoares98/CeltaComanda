import 'package:clean_celta_mobile/domain/usecases/payment/payment.dart';
import 'package:clean_celta_mobile/presentation/mixins/mixins.dart';
import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:clean_celta_mobile/ui/pages/payment/payment_presenter.dart';
import 'package:get/get.dart';

import '../../domain/helpers/helpers.dart';

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
    isLoading = false;
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
  Future<void> payWithCredithPortion({
    required double longAmountValue,
    required int portionQuantity,
  }) async {
    mainError = null;
    isLoading = false;
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
    isLoading = false;
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
    isLoading = false;
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
