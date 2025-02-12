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
  final _userNameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _userNameFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();

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

    _userNameController.dispose();
    _passwordController.dispose();
    _passwordFocusNode.dispose();
    _userNameFocusNode.dispose();
  }

  Future<void> goToConfigurationsPage(
    ConfigurationsPresenter configurationsPrsenter,
  ) async {
    bool? isValid = _formKey.currentState?.validate();

    if (isValid == true) {
      _userNameFocusNode.unfocus();
      _passwordFocusNode.unfocus();

      Navigator.of(context).pop();

      await configurationsPrsenter.login(
        username: _userNameController.text,
        password: _passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  key: _formKey,
                  child: Column(
                    children: [
                      UserNameInput(
                        passwordFocusNode: _passwordFocusNode,
                        userNameController: _userNameController,
                        userNameFocusNode: _userNameFocusNode,
                      ),
                      const SizedBox(height: 10),
                      PasswordInput(
                          passwordFocusNode: _passwordFocusNode,
                          passwordController: _passwordController,
                          goToConfigurationsPage: () async {
                            await goToConfigurationsPage(
                                configurationsPresenter);
                          }),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: GoToConfigurationsPageButton(
                    goToConfigurationsPage: () async {
                      await goToConfigurationsPage(configurationsPresenter);
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
