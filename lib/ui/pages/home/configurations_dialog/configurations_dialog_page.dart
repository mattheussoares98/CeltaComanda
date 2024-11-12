import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../ui/helpers/helpers.dart';
import '../../pages.dart';

class ConfigurationsDialogPage extends StatefulWidget {
  const ConfigurationsDialogPage({super.key});

  @override
  State<ConfigurationsDialogPage> createState() =>
      _ConfigurationsDialogPageState();
}

class _ConfigurationsDialogPageState extends State<ConfigurationsDialogPage> {
  final _userCodeController = TextEditingController();
  final _passwordController = TextEditingController();
  final _userCodeFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _keyUserAndPassword = GlobalKey<FormState>();
  final _keyDropdowns = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    HomePresenter homePresenter = Provider.of(context, listen: false);

    if (homePresenter.commandNumber != null) {
      homePresenter.updateSelectedCommand(homePresenter.commandNumber!.toInt());
    }
  }

  @override
  void dispose() {
    super.dispose();

    _userCodeController.dispose();
    _passwordController.dispose();
    _passwordFocusNode.dispose();
    _userCodeFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Form(
                  key: _keyUserAndPassword,
                  child: Column(
                    children: [
                      UserPersonalizedCodeInput(
                        passwordFocusNode: _passwordFocusNode,
                        userController: _userCodeController,
                        userCodeFocusNode: _userCodeFocusNode,
                      ),
                      const SizedBox(height: 10),
                      PasswordInput(
                        passwordFocusNode: _passwordFocusNode,
                        passwordController: _passwordController,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: ActionsButtons(
                    passwordController: _passwordController,
                    userCodeController: _userCodeController,
                    keyUserAndPassword: _keyUserAndPassword,
                    userCodeFocusNode: _userCodeFocusNode,
                    passwordFocusNode: _passwordFocusNode,
                    keyDropdowns: _keyDropdowns,
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
