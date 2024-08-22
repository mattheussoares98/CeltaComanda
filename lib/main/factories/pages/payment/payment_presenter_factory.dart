import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/pages/pages.dart';

import '../../factories.dart';

PaymentPresenter makeGetxPaymentPresenter() => GetxPaymentPresenter(
      pay: makeRedePay(),
      loadPrintedProducts: makeRemoteLoadPrintedProducts(),
      barcodeScanner: makeCameraBarcodeScanner(),
      openOrBlockade: makeRemoteOpenOrBlockad(),
    );
