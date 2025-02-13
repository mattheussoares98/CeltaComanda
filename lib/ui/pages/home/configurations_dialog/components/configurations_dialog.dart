import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../ui/helpers/helpers.dart';
import '../../../pages.dart';

class ConfigurationsDialogPage extends StatefulWidget {
  const ConfigurationsDialogPage({super.key});

  @override
  State<ConfigurationsDialogPage> createState() =>
      _ConfigurationsDialogPageState();
}

class _ConfigurationsDialogPageState extends State<ConfigurationsDialogPage> {
  final passwordController = TextEditingController();
  final passwordFocusNode = FocusNode();
  final formKey = GlobalKey<FormState>();
  UserConcentratorViewModel? selectedUser;

  @override
  void initState() {
    super.initState();
    HomePresenter homePresenter = Provider.of(context, listen: false);

    if (homePresenter.commandEntity?.commandNumber != null) {
      homePresenter.updateSelectedCommand(
          homePresenter.commandEntity!.commandNumber!.toInt());
    }
  }

  @override
  void dispose() {
    super.dispose();

    passwordController.dispose();
    passwordFocusNode.dispose();
  }

  Future<void> goToConfigurationsPage(
    HomePresenter homePresenter,
    ConfigurationsPresenter configurationsPresenter,
  ) async {
    bool? isValid = formKey.currentState?.validate();

    if (isValid == true) {
      passwordFocusNode.unfocus();

      Navigator.of(context).pop();

      await homePresenter.newGoToConfigurationsPage(
        username: selectedUser!.Name!,
        password: passwordController.text,
        configurationsPresenter: configurationsPresenter,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    HomePresenter homePresenter = Provider.of(context, listen: false);
    ConfigurationsPresenter configurationsPresenter =
        Provider.of(context, listen: false);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SizedBox(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      SelectUserDropDown(
                        selectedUser: selectedUser,
                        updateSelectedUser: (value) {
                          setState(() {
                            selectedUser = value;
                          });
                        },
                      ),
                      const SizedBox(height: 10),
                      PasswordInput(
                          passwordFocusNode: passwordFocusNode,
                          passwordController: passwordController,
                          goToConfigurationsPage: () async {
                            await goToConfigurationsPage(
                              homePresenter,
                              configurationsPresenter,
                            );
                          }),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: GoToConfigurationsPageButton(
                    goToConfigurationsPage: () async {
                      await goToConfigurationsPage(
                        homePresenter,
                        configurationsPresenter,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
