import '../../../../ui/pages/pages.dart';
import 'product_details.dart';

ProductDetailsPage makeProductDetailsPage() => ProductDetailsPage(
      makeGetxProductDetailsPresenter(),
    );
