import '../../../../presentation/presenters/presenters.dart';
import '../../../factories/factories.dart';

GetxProductDetailsPresenter makeGetxProductDetailsPresenter() =>
    GetxProductDetailsPresenter(
      navigateTo: makeNavigateTo(),
    );
