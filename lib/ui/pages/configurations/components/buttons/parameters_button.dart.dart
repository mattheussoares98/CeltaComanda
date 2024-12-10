import 'package:flutter/material.dart';

import '../components.dart';

class ParametersButton extends StatelessWidget {
  const ParametersButton({super.key});

  @override
  Widget build(BuildContext context) {
    return defaultButton(
      context: context,
      isNew: true,
      name: "" + "parameters",
      function: () async {},
    );
  }
}
