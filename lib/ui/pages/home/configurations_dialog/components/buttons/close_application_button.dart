import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../helpers/helpers.dart';
import '../../../../pages.dart';

class CloseApplicationButton extends StatelessWidget {
  final Future<bool> Function() validateUserCredentials;
  const CloseApplicationButton({
    required this.validateUserCredentials,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    HomePresenter homePresenter = Provider.of(context, listen: false);

    return ElevatedButton(
      onPressed: () async {
        if (await validateUserCredentials()) {
          await homePresenter.closeApp();
        }
      },
      child: Text(R.string.closeApplication),
    );
  }
}
