import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../helpers/helpers.dart';
import '../../../../pages.dart';

class GoToConfigurationsPageButton extends StatelessWidget {
  final TextEditingController userCodeController;
  final TextEditingController passwordController;

  const GoToConfigurationsPageButton({
    required this.userCodeController,
    required this.passwordController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    HomePresenter homePresenter = Provider.of(context, listen: false);

    return ElevatedButton(
      onPressed: () async {
        await homePresenter.goToConfigurationsPage(
          userPersonalizedCode: userCodeController.text.toInt(),
          password: passwordController.text,
        );
      },
      child: Text(R.string.configurations),
    );
  }
}
