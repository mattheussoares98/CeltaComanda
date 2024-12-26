import '../../../../main/factories/factories.dart';
import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/pages/pages.dart';

SaleMovementPresenter makeGetxSaleMovementPresenter() =>
    GetxSaleMovementPresenter(
      loadSaleMovementConcentrator: makeRemoteLoadSaleMovementConcentrator(),
    );
