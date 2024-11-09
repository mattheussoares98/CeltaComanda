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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Form(
                key: _keyDropdowns,
                child: const Column(
                  children: [
                    SizedBox(height: 10),
                    UpdateCommandNumberDropdown(),
                    SizedBox(height: 10),
                    UpdatePeopleNumbersDropdown(),
                    SizedBox(height: 10),
                    UpdateSellerDropdown(),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Form(
                key: _keyUserAndPassword,
                child: Column(
                  children: [
                    UserPersonalizedCodeInput(
                      passwordFocusNode: _passwordFocusNode,
                      userController: _userCodeController,
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
                  keyDropdowns: _keyDropdowns,
                ),
              ),
              const UpdateMenuButton(),
            ],
          ),
        ),
      ),
    );
  }
}
