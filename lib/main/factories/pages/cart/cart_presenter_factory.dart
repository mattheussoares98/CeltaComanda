import 'package:clean_celta_mobile/main/factories/usecases/usecases.dart';
import 'package:clean_celta_mobile/presentation/presenters/getx_cart_presenter.dart';

import '../../../../ui/pages/pages.dart';

CartPresenter makeGetxCartPresenter() => GetxCartPresenter(
      navigateTo: makeNavigateTo(),
    );
