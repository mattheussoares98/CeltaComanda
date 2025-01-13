import 'package:flutter/material.dart';

class PrintProductsTestButton extends StatelessWidget {
  const PrintProductsTestButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {},
      icon: Icon(
        Icons.print_disabled,
      ),
    );
  }
}
