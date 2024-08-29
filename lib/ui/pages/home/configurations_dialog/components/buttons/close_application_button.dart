import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../helpers/helpers.dart';

class CloseApplicationButton extends StatelessWidget {
  final Future<bool> Function() validateUserCredentials;
  const CloseApplicationButton({
    required this.validateUserCredentials,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        if (await validateUserCredentials()) {
          const platform = MethodChannel('persistent_channel');

          try {
            Future.delayed(Duration.zero, () async {
              final result = await platform.invokeMethod("closeApp");
              debugPrint(result);
            });
          } catch (e) {
            debugPrint(e.toString());
          }
        }
      },
      child: Text(R.string.closeApplication),
    );
  }
}
