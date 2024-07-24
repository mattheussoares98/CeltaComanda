import 'package:flutter/material.dart';

import '../../../components/components.dart';
import '../../pages.dart';

class CartPageDialog {
  static bool isOpen = false;

  static Future<void> open(BuildContext context) async {
    isOpen = true;

    await showDialog(
        context: context,
        builder: (context) {
          return Dismissible(
            direction: DismissDirection.startToEnd,
            key: UniqueKey(),
            onDismissed: (_) {
              Navigator.of(context).pop();
              isOpen = false;
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                      isOpen = false;
                    },
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
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
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
  }
}
