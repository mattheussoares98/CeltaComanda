import 'package:clean_celta_mobile/ui/components/close_page_icon_button.dart';
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
              return Dismissible(
                key: UniqueKey(),
                onDismissed: (_) => Navigator.of(context).pop(),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: Navigator.of(context).pop,
                        child: Container(
                          height: double.infinity,
                          color: Colors.transparent,
                          child: const Align(
                            alignment: Alignment.topCenter,
                            child: ClosePageIconButton(),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 9,
                      child: AlertDialog(
                        insetPadding: const EdgeInsets.all(0),
                        contentPadding: const EdgeInsets.all(0),
                        content: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: const CartPage(),
                        ),
                      ),
                    ),
                  ],
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
