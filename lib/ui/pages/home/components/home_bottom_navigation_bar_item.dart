import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../pages.dart';
import 'components.dart';

class HomeBottomNavigationBarItem extends StatelessWidget {
  final Function(int)? onPageChanged;
  final int currentIndex;
  const HomeBottomNavigationBarItem({
    required this.onPageChanged,
    required this.currentIndex,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    CartPresenter cartPresenter = Provider.of(context, listen: false);
    PrintedProductsPresenter printedProductsPresenter =
        Provider.of(context, listen: false);

    return BottomNavigationBar(
      unselectedItemColor: Theme.of(context).primaryColorLight,
      selectedItemColor: Theme.of(context).primaryColorDark,
      // selectedIconTheme:
      //     IconThemeData(color: Theme.of(context).secondaryHeaderColor),
      showUnselectedLabels: true,
      currentIndex: currentIndex,
      onTap: onPageChanged,
      items: [
        const BottomNavigationBarItem(
          icon: Icon(
            Icons.menu_book_rounded,
          ),
          label: 'Menu',
        ),
        BottomNavigationBarItem(
          key: const Key("BottomNavigationExpansibleGroups"),
          icon: IconWithNumberQuantity(
            iconData: Icons.shopping_cart,
            productsQuantity: cartPresenter.cartProducts.length +
                cartPresenter.confirmedCombox.length,
          ),
          label: 'Carrinho',
        ),
        BottomNavigationBarItem(
          icon: IconWithNumberQuantity(
            iconData: Icons.list_outlined,
            productsQuantity:
                printedProductsPresenter.printedProducts == null ||
                        printedProductsPresenter
                                .printedProducts?.Products.isEmpty ==
                            true
                    ? 0
                    : printedProductsPresenter.printedProducts!.Products.length,
          ),
          label: 'Solicitados',
        ),
        if (cartPresenter.isGeneratingVersionToRede)
          const BottomNavigationBarItem(
            icon: Icon(Icons.paypal),
            label: 'Pagar',
          ),
      ],
    );
  }
}
