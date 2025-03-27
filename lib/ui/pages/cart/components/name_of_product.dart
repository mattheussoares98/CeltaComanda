import 'package:flutter/widgets.dart';

import '../../../helpers/helpers.dart';

class NameOfProduct extends StatelessWidget {
  final String name;
  const NameOfProduct({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Text(
      name,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: StringSize.size,
      ),
    );
  }
}
