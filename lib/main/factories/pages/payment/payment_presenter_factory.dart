import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/pages/pages.dart';

import '../../factories.dart';

PaymentPresenter makeGetxPaymentPresenter() => GetxPaymentPresenter(
      pay: makeRedePay(),
      commandInformations: makeRemoteCommandInformations(),
      finishSaleRequestConcentrador: makeRemoteFinishSaleRequestConcentrador(),
      alreadyPaid: makeLocalAlreadyPaid(),
      navigateTo: makeNavigateTo(),
    );
