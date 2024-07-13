import 'package:flutter/material.dart';

import '../../../../ui/helpers/helpers.dart';

class FatherNameText extends StatelessWidget {
  final String name;
  const FatherNameText({
    required this.name,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      name,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: getStringSize(context),
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).primaryColorDark,
      ),
    );
  }
}
