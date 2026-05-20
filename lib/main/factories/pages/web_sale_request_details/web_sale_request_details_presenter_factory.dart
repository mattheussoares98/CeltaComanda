import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/pages/pages.dart';
import '../../factories.dart';

WebSaleRequestDetailsPresenter makeGetxWebSaleRequestDetailsPresenter() =>
    GetxWebSaleRequestDetailsPresenter(
      loadEnterpriseData: makeRemoteLoadEnterpriseData(),
      localEntepriseData: makeLocalEnterpriseData(),
      navigateTo: makeNavigateTo(),
      loadPrintedProducts: makeRemoteLoadPrintedProducts(),
      webLoadSettings: makeLocalWebLoadSettings(),
      concDeliveryControl: makeConcDeliveryControl(),
      concLoadSaleMovement: makeRemoteLoadSaleMovementConcentrator(),
    );
