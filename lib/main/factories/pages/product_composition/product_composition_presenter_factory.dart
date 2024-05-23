import '../../../../main/factories/factories.dart';
import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/pages/pages.dart';

ProductCompositionPresenter makeGetxProductCompositionPresenter() =>
    GetxProductCompositionPresenter(
      getProductComposition: makeRemoteGetProductComposition(),
      updateSaleRequestTemp: makeRemoteUpdateSaleRequestTemp(),
    );
