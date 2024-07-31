import 'package:flutter/material.dart';

import '../../../helpers/helpers.dart';

class TitleText extends StatelessWidget {
  final String text;
  const TitleText({
    required this.text,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Text(
        text,
        style: TextStyle(
          color: Theme.of(context).primaryColorDark,
          fontWeight: FontWeight.bold,
          fontSize: getStringSize(context) * 1.4,
        ),
      ),
    );
  }
}
