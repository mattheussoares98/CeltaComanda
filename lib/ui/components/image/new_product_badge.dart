import 'package:flutter/material.dart';
import 'dart:math' as math;

import '../../helpers/helpers.dart';

class NewProductBadge extends StatelessWidget {
  final double height;
  const NewProductBadge({
    required this.height,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            bottomRight: Radius.circular(10),
          ),
          color: Colors.red.withOpacity(0.7),
        ),
        child: Padding(
          padding: EdgeInsets.all(height * 0.25),
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
