import 'package:flutter/material.dart';

class ClosePageIconButton extends StatelessWidget {
  const ClosePageIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      icon: const CircleAvatar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        child: FittedBox(
          child: Icon(
            Icons.close,
            size: 40,
          ),
        ),
      ),
    );
  }
}
