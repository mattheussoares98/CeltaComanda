import 'package:flutter/material.dart';
import 'dart:math' as math;

import '../../helpers/helpers.dart';

class NewProduct extends StatelessWidget {
  const NewProduct({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      child: Container(
        height: 50,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(10),
          ),
          color: Colors.red,
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Transform.rotate(
            angle: -math.pi / 4,
            child: Center(
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
