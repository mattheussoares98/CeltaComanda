import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../components/components.dart';
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
    HomePresenter homePresenter = Provider.of(context, listen: false);
    PrintedProductsPresenter printedProductsPresenter =
        Provider.of(context, listen: false);

    final List<Widget> buttons = [
      UpdateConfigurationsButton(
        updateCommand: () async {
          await _updateCommand(
            homePresenter: homePresenter,
            printedProductsPresenter: printedProductsPresenter,
            context: context,
            keyUserAndPassword: keyUserAndPassword,
            keyDropdowns: keyDropdowns,
            passwordController: passwordController,
            userCodeController: userCodeController,
          );
        },
      ),
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

Future<void> _updateCommand({
  required HomePresenter homePresenter,
  required PrintedProductsPresenter printedProductsPresenter,
  required BuildContext context,
  required GlobalKey<FormState> keyDropdowns,
  required GlobalKey<FormState> keyUserAndPassword,
  required TextEditingController passwordController,
  required TextEditingController userCodeController,
}) async {
  FocusScope.of(context).unfocus();

  if (keyDropdowns.currentState?.validate() != true ||
      keyUserAndPassword.currentState?.validate() != true) {
    return;
  }

  final updated = await homePresenter.updateCommandData(
    newFixedCommandNumber: homePresenter.selectedCommand!,
    userPersonalizedCode: userCodeController.text.toInt(),
    password: passwordController.text,
    printedProductsPresenter: printedProductsPresenter,
    peoples: homePresenter.selectedPeoples,
    sellerCode: homePresenter.selectedSeller?.PersonalizedCode,
  );

  if (updated) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      FocusScope.of(context).unfocus();
      snackBarMessage(
        context,
        R.string.msgUpdatedTableConfigurationsSuccess,
      );
    });
  }
}
