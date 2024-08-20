import 'package:flutter/material.dart';

Widget pepperIndicator(String? productComplement) {
  String lowerCaseComplement = productComplement.toString().toLowerCase();

  if (lowerCaseComplement.contains("(p)") == true) {
    return _pepperImage();
  } else if (lowerCaseComplement.contains("(pp)") == true) {
    return Row(
      children: [
        _pepperImage(),
        _pepperImage(),
      ],
    );
  } else if (lowerCaseComplement.contains("(ppp)") == true) {
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
