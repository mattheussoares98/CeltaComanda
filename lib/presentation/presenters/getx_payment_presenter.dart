import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../data/models/models.dart';
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
  final NavigateTo navigateTo;

  GetxPaymentPresenter({
    required this.pay,
    required this.commandInformations,
    required this.finishSaleRequestConcentrador,
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
  Future<void> liquidateCommand({
    required HomePresenter homePresenter,
    required PrintedProductsPresenter printedProductsPresenter,
  }) async {
    mainError = null;
    isLoading = true;
    try {
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

      await printedProductsPresenter.loadPrinted(homePresenter);
    } catch (e) {
      mainError = UIError.unexpected;
    } finally {
      isLoading = false;
    }
  }

  MethodChannel? _channel;
  @override
  void initPaymentResultHandler(
    HomePresenter homePresenter,
    PrintedProductsPresenter printedProductsPresenter,
  ) {
    if (homePresenter.isGeneratingVersionToGetNet) {
      _channel = MethodChannel(Channels.getnet.name);
    } else if (homePresenter.isGeneratingVersionToRede) {
      _channel = MethodChannel(Channels.rede.name);
    } else {
      return;
    }

    _channel?.setMethodCallHandler((MethodCall call) async {
      if (homePresenter.isGeneratingVersionToRede) {
        await _treatRedeResponse(homePresenter, printedProductsPresenter, call);
      } else {
        await _treatGetNetResponse(
          homePresenter,
          printedProductsPresenter,
          call,
        );
      }
    });
  }

  Future<void> _treatGetNetResponse(
    HomePresenter homePresenter,
    PrintedProductsPresenter printedProductsPresenter,
    MethodCall call,
  ) async {
    try {
      final response = GetNetResponseModel.fromJson(call.arguments);
      if (response.result == "0") {
        await liquidateCommand(
          homePresenter: homePresenter,
          printedProductsPresenter: printedProductsPresenter,
        );
      } else if (response.result == "1") {
        mainError = UIError.paymentDeclined;
      } else if (response.result == "2") {
        mainError = UIError.paymentCanceled;
      } else if (response.result == "3") {
        mainError = UIError.paymentFailed;
      } else if (response.result == "4") {
        mainError = UIError.paymentUnexpectedError;
      } else if (response.result == "5") {
        mainError = UIError.paymentPendant;
      } else {
        mainError = UIError.paymentUnexpectedError;
      }
    } catch (e) {
      mainError = UIError.unexpected;
    }
  }

  Future<void> _treatRedeResponse(
    HomePresenter homePresenter,
    PrintedProductsPresenter printedProductsPresenter,
    MethodCall call,
  ) async {
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
  }

  @override
  void disposePaymentResultHandler() {
    _channel?.setMethodCallHandler(null);
  }

  @override
  void goToCovenantPage() {
    navigateTo.navigate(pageRoute: PageRoutes.covenant);
  }
}
