import 'package:flutter/material.dart';

class AlcoholicBadge extends StatelessWidget {
  final double height;
  final double width;
  const AlcoholicBadge({
    required this.height,
    required this.width,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      right: 0,
      child: Image.asset(
        "lib/ui/assets/images/prohibed_for_minors.png",
        fit: BoxFit.cover,
        height: width > height ? height : width,
        width: width > height ? height : width,
      ),
    );
  }
}
