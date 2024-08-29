import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../../../helpers/helpers.dart';
import '../../../../pages.dart';

class CloseApplicationButton extends StatelessWidget {
  final Future<bool> Function(HomePresenter homePresenter)
      validateUserCredentials;
  const CloseApplicationButton({
    required this.validateUserCredentials,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    HomePresenter homePresenter = Provider.of(context, listen: false);

    return ElevatedButton(
      onPressed: () async {
        if (await validateUserCredentials(homePresenter)) {
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
