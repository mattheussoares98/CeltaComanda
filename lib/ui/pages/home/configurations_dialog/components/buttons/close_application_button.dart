import 'package:flutter/material.dart';

import '../../../../../helpers/helpers.dart';
import '../../../../../mixins/mixins.dart';

class CloseApplicationButton extends StatelessWidget with BehaviorManager {
  final Future<bool> Function() validateUserCredentials;
  CloseApplicationButton({
    required this.validateUserCredentials,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        if (await validateUserCredentials()) {
          await closeApp();
        }
      },
      child: Text(R.string.closeApplication),
    );
  }
}
