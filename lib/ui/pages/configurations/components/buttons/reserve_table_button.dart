import 'package:flutter/material.dart';

import '../../../../../domain/helpers/helpers.dart';
import '../../../../../main/builders/builders.dart';
import '../../../../helpers/helpers.dart';
import '../../../pages.dart';

class ReserveTableButton extends StatelessWidget {
  const ReserveTableButton({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultButton(
        name: R.string.reserveTable,
        permissionName: Permissions.reservarMesa,
        function: () async {
          Navigator.of(NavigatorKey.key.currentState!.context)
              .popUntil(
            (route) => route.isFirst,
          );

          await Future.delayed(Duration.zero, () {});

          showDialog(
              // ignore: use_build_context_synchronously
              context: context,
              builder: (context) {
                return const ReserveTable();
              });
        });
  }
}
