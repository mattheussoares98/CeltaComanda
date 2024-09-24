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
      return ElevatedButton(
        style: ElevatedButton.styleFrom(shape: const RoundedRectangleBorder()),
        onPressed: onPress,
        child: Stack(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Icon(
                    icon,
                    size: hasMinWidth(context) ? 30 : 17,
                  ),
                ),
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
        ),
      );
    } else {
      return InkWell(
        onTap: onPress,
        child: Container(
          color: Colors.black,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: hasMinWidth(context) ? 16 : 5,
              vertical: 1,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(child: Icon(icon, color: Colors.white)),
                      SizedBox(width: hasMinWidth(context) ? 3 : 0),
                      Center(
                        child: hasMinWidth(context)
                            ? Text(buttonName.toUpperCase(),
                                style: const TextStyle(color: Colors.white))
                            : null,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 2),
                Container(
                  color: Colors.black,
                  child: InkWell(
                    onTap: onPress,
                    child: FittedBox(
                      child: Text(
                        quantityString
                            .toDouble()
                            .toString()
                            .toBrazilianNumber()
                            .addBrazilianCoin(),
                        style: TextStyle(
                          color: Theme.of(context).secondaryHeaderColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}
