import 'package:flutter/material.dart';

import '../../../../../helpers/helpers.dart';
import '../../../../pages.dart';

class ActionsButtons extends StatelessWidget {
  final TextEditingController passwordController;
  final TextEditingController userCodeController;
  final FocusNode userCodeFocusNode;
  final FocusNode passwordFocusNode;
  final GlobalKey<FormState> keyUserAndPassword;
  final GlobalKey<FormState> keyDropdowns;

  const ActionsButtons({
    required this.userCodeFocusNode,
    required this.passwordFocusNode,
    required this.passwordController,
    required this.userCodeController,
    required this.keyUserAndPassword,
    required this.keyDropdowns,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final List<Widget> buttons = [
      GoToConfigurationsPageButton(
        userCodeController: userCodeController,
        passwordController: passwordController,
        keyUserAndPassword: keyUserAndPassword,
        userCodeFocusNode: userCodeFocusNode,
        passwordFocusNode: passwordFocusNode,
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: hasMinWidth(context) ? 3 : 2,
        childAspectRatio: hasMinWidth(context) ? 5 : 3,
        mainAxisSpacing: 5,
        crossAxisSpacing: 5,
      ),
      itemCount: buttons.length,
      itemBuilder: (context, index) {
        return buttons[index];
      },
    );
  }
}
