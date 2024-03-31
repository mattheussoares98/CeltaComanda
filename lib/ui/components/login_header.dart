import 'package:flutter/material.dart';

import 'loading_image.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 240,
      margin: const EdgeInsets.only(top: 20),
      child: loadingImage(),
    );
  }
}
