import 'package:clean_celta_mobile/main/factories/usecases/printed_products/user_validations_factory.dart';

import '../../../../main/factories/usecases/usecases.dart';
import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/pages/pages.dart';

PrintedProductsPresenter makeGetxPrintedProductsPresenter() =>
    GetxPrintedProductsPresenter(
      navigateTo: makeNavigateTo(),
      userValidations: makeRemoteUserValidations(),
    );
