import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/pages/pages.dart';
import '../../usecases/load_cross_id_factory.dart';

SplashPresenter makeGetxSplashPresenter() =>
  GetxSplashPresenter(loadCrossId: makeLocalLoadCrossId());