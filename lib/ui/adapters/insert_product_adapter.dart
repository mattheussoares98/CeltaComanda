import 'package:clean_celta_mobile/ui/pages/pages.dart';

import '../helpers/helpers.dart';

class InsertProductAdapter {
  final ProductsViewModel selectedProduct;
  final int totalProductsQuantity;
  final Stream<bool> isLoadingStream;
  final Stream<bool> showCommentsStream;
  final Stream<bool> doScrollStream;
  final Stream<int> selectedItemIndexStream;
  final Stream<double> totalPriceStream;
  final Stream<UIError?> mainErrorStream;
  final Stream<ProductsViewModel?> selectedComboxProductStream;
  final Function() doOnClosePage;
  final Function() updateSelectedProduct;
  final Function() updateTotalLiquid;
  final Function() advanceSelectedIndex;
  final Function() addInCart;

  InsertProductAdapter({
    required this.selectedProduct,
    required this.totalProductsQuantity,
    required this.isLoadingStream,
    required this.showCommentsStream,
    required this.doScrollStream,
    required this.mainErrorStream,
    required this.selectedItemIndexStream,
    required this.doOnClosePage,
    required this.selectedComboxProductStream,
    required this.updateSelectedProduct,
    required this.totalPriceStream,
    required this.updateTotalLiquid,
    required this.advanceSelectedIndex,
    required this.addInCart,
  });
}
