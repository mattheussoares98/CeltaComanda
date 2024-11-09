import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../helpers/helpers.dart';
import '../../../../pages.dart';

class GoToConfigurationsPageButton extends StatelessWidget {
  final TextEditingController userCodeController;
  final TextEditingController passwordController;
  final GlobalKey<FormState> keyUserAndPassword;
  final FocusNode userCodeFocusNode;
  final FocusNode passwordFocusNode;

  const GoToConfigurationsPageButton({
    required this.userCodeController,
    required this.passwordController,
    required this.keyUserAndPassword,
    required this.userCodeFocusNode,
    required this.passwordFocusNode,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    HomePresenter homePresenter = Provider.of(context, listen: false);

    return ElevatedButton(
      onPressed: () async {
        bool? isValid = keyUserAndPassword.currentState?.validate();

        if (isValid == true) {
          userCodeFocusNode.unfocus();
          passwordFocusNode.unfocus();

          await homePresenter.goToConfigurationsPage(
            userPersonalizedCode: userCodeController.text.toInt(),
            password: passwordController.text,
          );

          userCodeController.clear();
          passwordController.clear();
        }
      },
      child: Text(R.string.configurations),
    );
  }
}
