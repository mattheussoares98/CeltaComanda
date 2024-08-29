import 'package:flutter/material.dart';

import '../../../../../helpers/helpers.dart';
import '../../../../pages.dart';

class ReserveTableButton extends StatelessWidget {
  const ReserveTableButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).pop();
        showDialog(
            context: context,
            builder: (context) {
              return const ReserveTable();
            });
      },
      child: FittedBox(
        child: Padding(
          padding: EdgeInsets.all(hasMinWidth(context) ? 8.0 : 0),
          child: Text(
            R.string.reserveTable,
            style: TextStyle(
              fontSize: getStringSize(context),
            ),
          ),
        ),
      ),
    );
  }
}
