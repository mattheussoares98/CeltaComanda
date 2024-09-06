import 'package:flutter/material.dart';

import '../../../helpers/helpers.dart';
import '../../pages.dart';

class RequestedAt extends StatelessWidget {
  final PrintedViewModel printed;
  const RequestedAt({
    required this.printed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(hasMinWidth(context) ? 5 : 3),
      child: Text(
        "${DateTime.parse(printed.DateHourOfCreation).hour}:${DateTime.parse(printed.DateHourOfCreation).minute}",
        style: TextStyle(
          fontSize: getStringSize(context) * 0.8,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }
}
