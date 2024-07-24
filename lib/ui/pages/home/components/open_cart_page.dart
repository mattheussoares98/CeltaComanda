import 'package:flutter/material.dart';

import '../../pages.dart';

class OpenCartPage extends StatelessWidget {
  const OpenCartPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(shape: const RoundedRectangleBorder()),
      onPressed: () {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                insetPadding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.1),
                contentPadding: const EdgeInsets.all(0),
                content: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: const Align(
                    alignment: Alignment.centerRight,
                    child: CartPage(),
                  ),
                ),
              );
            });
      },
      label: const Center(
        child: Text(
          "CARRINHO",
        ),
      ),
      icon: const Icon(Icons.shopping_cart_outlined),
    );
  }
}
