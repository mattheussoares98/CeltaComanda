import 'package:flutter/services.dart';
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
  final NavigateTo navigateTo;

  GetxPaymentPresenter({
    required this.pay,
    required this.commandInformations,
    required this.finishSaleRequestConcentrador,
    required this.alreadyPaid,
    required this.navigateTo,
  });

  @override
  Future<void> callPayment({
    required double longAmountValue,
    required int portionQuantity,
    required PaymentMode paymentMode,
    required HomePresenter homePresenter,
  }) async {
    mainError = null;
    isLoading = true;
    try {
      bool isValid = await commandInformations.isValidDatetime(
        commandNumber: homePresenter.commandNumber!,
      );

      if (!isValid) {
        throw DomainError.blockedCommand;
      }

      await pay.pay(
        paymentMode: paymentMode,
        channel: homePresenter.isGeneratingVersionToRede
            ? Channels.rede
            : Channels.getnet,
        params: PayParams(
          longAmountValue: (longAmountValue * 100).toInt(),
          portionQuantity: portionQuantity,
        ),
      );
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
  Future<void> getAndUpdateAlreadyPaidCommand() async {
    try {
      _commandAlreadyPaid = await alreadyPaid.verify();
    } catch (e) {
      mainError = UIError.unexpected;
    }
  }

  @override
  Future<void> liquidateCommand({
    required HomePresenter homePresenter,
    required PrintedProductsPresenter printedProductsPresenter,
  }) async {
    mainError = null;
    isLoading = true;
    try {
      await alreadyPaid.update(true);
      _commandAlreadyPaid = true;

      await finishSaleRequestConcentrador.finish(
        pdvNumber: 100,
        commandNumber: homePresenter.commandNumber!.toInt(),
        finalizations: null,
        //finalizations
        // Money = 1,
        // Check = 2,
        // PIX = 3,
        // PurchaseVale = 4,
        // DebitCard = 5,
        // CreditCard = 6,
        // Covenant = 7,
        // POS = 8,
        // Portion = 9,
        // FinancialCredits = 10
      );

      await alreadyPaid.update(false);
      _commandAlreadyPaid = false;

      await printedProductsPresenter.loadPrinted(homePresenter);
    } catch (e) {
      mainError = UIError.unexpected;
      _commandAlreadyPaid = true;
    } finally {
      isLoading = false;
    }
  }

  bool _commandAlreadyPaid = false;
  @override
  bool get commandAlreadyPaid => _commandAlreadyPaid;

  final _channel = MethodChannel(Channels.rede.name);
  @override
  void initPaymentResultHandler(
    HomePresenter homePresenter,
    PrintedProductsPresenter printedProductsPresenter,
  ) {
    _channel.setMethodCallHandler((MethodCall call) async {
      if (call.arguments == "Pagamento Autorizado") {
        try {
          await liquidateCommand(
            homePresenter: homePresenter,
            printedProductsPresenter: printedProductsPresenter,
          );
        } catch (e) {
          mainError = UIError.liquidadeCommandError;
        }
      } else if (call.arguments == "Pagamento Falhou") {
        mainError = UIError.paymentFailed;
      } else if (call.arguments == "Pagamento cancelado") {
        mainError = UIError.paymentCanceled;
      } else if (call.arguments == "Pagamento Recusado") {
        mainError = UIError.paymentDeclined;
      } else {
        mainError = UIError.paymentUnexpectedError;
      }
    });
  }

  @override
  void disposePaymentResultHandler() {
    _channel.setMethodCallHandler(null);
  }

  @override
  void goToCovenantPage() {
    navigateTo.navigate(pageRoute: PageRoutes.covenant);
  }
}
