import 'package:flutter/material.dart';

class StepNumber extends StatelessWidget {
  final int stepNumber;
  const StepNumber({
    required this.stepNumber,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: CircleAvatar(
        backgroundColor: Colors.white,
        minRadius: 20,
        maxRadius: 20,
        child: Text(
          stepNumber.toString(),
          style: const TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
