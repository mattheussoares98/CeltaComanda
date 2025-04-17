import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../ui/helpers/helpers.dart';
import '../../../pages.dart';

class ConfigurationsDialogPage extends StatefulWidget {
  final bool onlyRemoveServiceChargeOnSuccess;
  const ConfigurationsDialogPage({
    super.key,
    required this.onlyRemoveServiceChargeOnSuccess,
  });

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
    PrintedProductsPresenter printedProductsPresenter,
  ) async {
    bool? isValid = formKey.currentState?.validate();

    if (isValid == true) {
      passwordFocusNode.unfocus();

      Navigator.of(context).pop();

      if (widget.onlyRemoveServiceChargeOnSuccess) {
        printedProductsPresenter.removeServiceCharge(
          commandNumber: homePresenter.commandEntity!.commandNumber!,
          printed: printedProductsPresenter.printed!,
        );
      } else {
        await homePresenter.newGoToConfigurationsPage(
          username: selectedUser!.Name!,
          password: passwordController.text,
          configurationsPresenter: configurationsPresenter,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    HomePresenter homePresenter = Provider.of(context, listen: false);
    ConfigurationsPresenter configurationsPresenter =
        Provider.of(context, listen: false);
    PrintedProductsPresenter printedProductsPresenter =
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
                if (homePresenter.commandEntity?.pdv?.PdvNumber != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                        "${R.string.pdv} ${homePresenter.commandEntity!.pdv!.PdvNumber!.toInt()}"),
                  ),
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
                              printedProductsPresenter,
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
                        printedProductsPresenter,
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
