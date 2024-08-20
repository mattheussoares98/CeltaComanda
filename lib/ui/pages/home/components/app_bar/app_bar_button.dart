import 'package:flutter/material.dart';

import '../../../../helpers/helpers.dart';

class AppBarButton extends StatelessWidget {
  final Function() onPress;
  final IconData? icon;
  final String buttonName;
  final String quantityString;
  final bool isPrice;
  const AppBarButton({
    required this.onPress,
    required this.icon,
    required this.buttonName,
    required this.quantityString,
    this.isPrice = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (!isPrice) {
      return Stack(
        children: [
          ElevatedButton(
            style:
                ElevatedButton.styleFrom(shape: const RoundedRectangleBorder()),
            onPressed: onPress,
            child: Row(
              mainAxisAlignment:
                  isPrice ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                Icon(icon),
                Center(
                  child: hasMinWidth(context)
                      ? Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Text(buttonName.toUpperCase()),
                        )
                      : null,
                ),
              ],
            ),
          ),
          Positioned(
            top: 2,
            left: 5,
            child: InkWell(
              onTap: onPress,
              child: CircleAvatar(
                backgroundColor: Colors.black,
                maxRadius: 8,
                minRadius: 8,
                child: Center(
                  child: FittedBox(
                    child: Text(
                      quantityString,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      return Column(
        children: [
          ElevatedButton(
            style:
                ElevatedButton.styleFrom(shape: const RoundedRectangleBorder()),
            onPressed: onPress,
            child: Row(
              mainAxisAlignment:
                  isPrice ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                Icon(icon),
                Center(
                  child: hasMinWidth(context)
                      ? Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Text(buttonName.toUpperCase()),
                        )
                      : null,
                ),
              ],
            ),
          ),
          Container(
            color: Colors.white,
            child: InkWell(
              onTap: onPress,
              child: FittedBox(
                child: Text(
                  quantityString,
                ),
              ),
            ),
          ),
        ],
      );
    }
  }
}
