import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/pages/pages.dart';
import '../../factories.dart';

WebSaleRequestDetailsPresenter makeGetxWebSaleRequestDetailsPresenter() =>
    GetxWebSaleRequestDetailsPresenter(
      loadEnterpriseData: makeRemoteLoadEnterpriseData(),
      localEntepriseData: makeLocalEnterpriseData(),
      navigateTo: makeNavigateTo(),
      concLoadSaleRequest: makeRemoteConcLoadSaleRequest(),
      loadDeliveryControl: makeConcLoadDeliveryControl(),
      webLoadSettings: makeLocalWebLoadSettings(),
    );
