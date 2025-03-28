import 'package:flutter/material.dart';

import '../../helpers/sizes/sizes.dart';

class KidsBadge extends StatelessWidget {
  final double height;
  final double width;
  const KidsBadge({
    required this.height,
    required this.width,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      right: ScreenSize.hasMinWidth ? width * 0.4 : 10,
      child: Image.asset(
        "lib/ui/assets/images/kids.png",
        fit: BoxFit.contain,
        height: width > height ? height : width,
        width: width > height ? height : width,
      ),
    );
  }
}
