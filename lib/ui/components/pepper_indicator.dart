import 'package:flutter/material.dart';

Widget pepperIndicator(String? productComplement) {
  if (productComplement?.contains("(P)") == true) {
    return _pepperImage();
  } else if (productComplement?.contains("(PP)") == true) {
    return Row(
      children: [
        _pepperImage(),
        _pepperImage(),
      ],
    );
  } else if (productComplement?.contains("(PPP)") == true) {
    return Row(
      children: [
        _pepperImage(),
        _pepperImage(),
        _pepperImage(),
      ],
    );
  } else {
    return const SizedBox();
  }
}

Widget _pepperImage() {
  return Image.asset(
    "lib/ui/assets/images/pepper.png",
    height: 20,
    width: 20,
    fit: BoxFit.cover,
  );
}
