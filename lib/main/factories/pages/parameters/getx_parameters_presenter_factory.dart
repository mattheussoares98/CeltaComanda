import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/pages/pages.dart';
import '../../factories.dart';

ParametersPresenter makeGetxParametersPresenter() => GetxParametersPresenter(
      navigateTo: makeNavigateTo(),
      parametersData: makeLocalParametersData(),
    );
