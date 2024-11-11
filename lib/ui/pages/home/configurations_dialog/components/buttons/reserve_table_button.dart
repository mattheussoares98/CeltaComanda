import 'package:flutter/material.dart';

import '../../../../../../main/builders/builders.dart';
import '../../../../../helpers/helpers.dart';
import '../../../../pages.dart';

class ReserveTableButton extends StatelessWidget {
  const ReserveTableButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        Navigator.of(NavigatorKey.navigatorKey.currentState!.context).popUntil(
          (route) => route.isFirst,
        );

        await Future.delayed(Duration.zero, () {});

        showDialog(
            // ignore: use_build_context_synchronously
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
