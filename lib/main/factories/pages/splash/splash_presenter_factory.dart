import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/pages/pages.dart';
import '../../usecases/cross_id/load_cross_id_factory.dart';

SplashPresenter makeGetxSplashPresenter() =>
  GetxSplashPresenter(loadCrossId: makeLocalLoadCrossId());