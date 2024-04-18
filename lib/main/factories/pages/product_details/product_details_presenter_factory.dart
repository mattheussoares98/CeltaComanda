import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/pages/pages.dart';
import '../../../factories/usecases/usecases.dart';

ProductDetailsPresenter makeGetxProductDetailsPresenter() =>
    GetxProductDetailsPresenter(
      navigateTo: makeNavigateTo(),
    );
