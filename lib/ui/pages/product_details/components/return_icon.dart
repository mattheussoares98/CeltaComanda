import 'package:flutter/material.dart';

class ReturnIcon extends StatelessWidget {
  const ReturnIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: const CircleAvatar(
        backgroundColor: Colors.grey,
        child: Icon(
          Icons.chevron_left_rounded,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }
}
