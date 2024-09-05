import 'package:clean_celta_mobile/main/builders/builders.dart';
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
  final CommandInformations commandInformations;
  final FinishSaleRequestConcentrador finishSaleRequestConcentrador;
  final AlreadyPaid alreadyPaid;

  GetxPaymentPresenter({
    required this.pay,
    required this.commandInformations,
    required this.finishSaleRequestConcentrador,
    required this.alreadyPaid,
  });

  @override
  Future<void> doPayment({
    required double longAmountValue,
    required int portionQuantity,
    required PaymentMode paymentMode,
    required String commandNumber,
  }) async {
    mainError = null;
    isLoading = true;
    try {
      bool isValid = await commandInformations.isValidDatetime(
        commandNumber: commandNumber,
      );

      if (!isValid) {
        throw DomainError.blockedCommand;
      }

      await pay.pay(
        paymentMode: paymentMode,
        params: PayParams(
          longAmountValue: (longAmountValue * 100).toInt(),
          portionQuantity: portionQuantity,
        ),
      );

      await alreadyPaid.update(true);

      await commandInformations.openOrBlockade(
        commandNumber: commandNumber,
        isOpen: true,
      );

      await finishSaleRequestConcentrador.finish(
        enterpriseId: EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId!,
        pdvNumber: 100,
        commandNumber: commandNumber.toInt(),
      );

      await alreadyPaid.update(false);
    } on DomainError catch (e) {
      switch (e) {
        case DomainError.blockedCommand:
          mainError = UIError.blockedCommand;
        default:
          mainError = UIError.unexpected;
      }
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

  @override
  Future<bool> getAlreadyPaid() async {
    try {
      return await alreadyPaid.verify();
    } catch (e) {
      mainError = UIError.unexpected;
      return false;
    }
  }

  @override
  Future<void> tryPayAgain(int commandNumber) async {
    mainError = null;
    isLoading = true;
    try {
      await finishSaleRequestConcentrador.finish(
        enterpriseId: EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId!,
        pdvNumber: 100,
        commandNumber: commandNumber.toInt(),
      );

      await alreadyPaid.update(false);
    } catch (e) {
      mainError = UIError.unexpected;
    } finally {
      isLoading = false;
    }
  }
}
