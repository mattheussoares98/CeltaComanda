import 'package:clean_celta_mobile/main/factories/pages/product_composition/product_composition_presenter_factory.dart';

import '../../../../ui/pages/pages.dart';

ProductCompositionPage makeProductCompositionPage() => ProductCompositionPage(
      makeGetxProductCompositionPresenter(),
    );
