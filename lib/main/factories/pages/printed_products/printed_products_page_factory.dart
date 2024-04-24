import 'package:clean_celta_mobile/main/factories/pages/printed_products/printed_products_presenter_factory.dart';

import '../../../../ui/pages/pages.dart';

PrintedProductsPage makePrintedProductsPage() => PrintedProductsPage(
      makeGetxPrintedProductsPresenter(),
    );
