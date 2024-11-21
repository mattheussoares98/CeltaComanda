import 'package:flutter/material.dart';

import '../../../helpers/helpers.dart';

class MakeLoginButton extends StatelessWidget {
  final Future<void> Function() makeLogin;
  const MakeLoginButton({
    required this.makeLogin,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        await makeLogin();
      },
      child: Text(R.string.login),
    );
  }
}
