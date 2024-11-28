import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/pages/pages.dart';
import '../../factories.dart';

SendProductsToAnotherTablePresenter
    makeGetxSendProductsToAnotherTablePresenter() =>
        GetxSendProductsToAnotherTablePresenter(
          loadPrintedProducts: makeRemoteLoadPrintedProducts(),
          changeSaleRequestPersonalizedCodeProducts:
              makeRemoteChangeSaleRequestPersonalizedCodeProducts(),
        );
