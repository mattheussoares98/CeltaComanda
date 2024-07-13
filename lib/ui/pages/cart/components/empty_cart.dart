import 'package:flutter/material.dart';

import '../../../helpers/helpers.dart';

class EmptyCart extends StatelessWidget {
  final PageController pageController;
  const EmptyCart({
    required this.pageController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height -
          AppBar().preferredSize.height -
          kBottomNavigationBarHeight,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FittedBox(
            child: Text(
              "O carrinho está vazio",
              style: TextStyle(
                fontSize: hasMinWidth(context) ? 30 : 20,
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Image.asset(
              key: const Key("emptyCartKey"),
              "lib/ui/assets/images/empty_cart.jpg",
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              pageController.jumpToPage(0);
            },
            label: Text(
              "Adicionar itens",
              style: TextStyle(
                fontSize: hasMinWidth(context) ? 25 : 20,
              ),
            ),
            icon: Icon(
              Icons.shopping_cart,
              size: hasMinWidth(context) ? 30 : 20,
            ),
          )
        ],
      ),
    );
  }
}
