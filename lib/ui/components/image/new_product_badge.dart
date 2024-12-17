import 'package:flutter/material.dart';
import 'dart:math' as math;

import '../../helpers/helpers.dart';

class NewProductBadge extends StatelessWidget {
  final double height;
  final double width;
  const NewProductBadge({
    required this.height,
    required this.width,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      child: Container(
        height: width > height ? height : width,
        width: width > height ? height : width,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            bottomRight: Radius.circular(10),
          ),
          color: Colors.red.withAlpha(178),
        ),
        child: Padding(
          padding:
              EdgeInsets.all(width > height ? height * 0.25 : width * 0.25),
          child: Transform.rotate(
            angle: -math.pi / 4,
            child: FittedBox(
              child: Text(
                R.string.neww,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
