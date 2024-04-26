import 'package:clean_celta_mobile/main/factories/factories.dart';

import '../../../../ui/pages/pages.dart';

PrintedProductsPage makePrintedProductsPage() => PrintedProductsPage(
      presenter: makeGetxPrintedProductsPresenter(),
    );
