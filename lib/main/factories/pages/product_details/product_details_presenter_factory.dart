import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/pages/pages.dart';
import '../../../factories/factories.dart';

ProductDetailsPresenter makeGetxProductDetailsPresenter() =>
    GetxProductDetailsPresenter(
      navigateTo: makeNavigateTo(),
    );
