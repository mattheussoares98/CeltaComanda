import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../ui/components/components.dart';
import '../../../../../ui/helpers/helpers.dart';
import '../../pages.dart';

class TableConfigurationsPage extends StatefulWidget {
  const TableConfigurationsPage({super.key});

  @override
  State<TableConfigurationsPage> createState() =>
      _TableConfigurationsPageState();
}

class _TableConfigurationsPageState extends State<TableConfigurationsPage> {
  final _personalizedCodeController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordFocusNode = FocusNode();
  final _keyUserAndPassword = GlobalKey<FormState>();
  final _keyDropdowns = GlobalKey<FormState>();

  Future<void> _updateCommandData(
    HomePresenter homePresenter,
    PrintedProductsPresenter printedProductsPresenter,
  ) async {
    FocusScope.of(context).unfocus();

    if (_keyDropdowns.currentState?.validate() != true ||
        _keyUserAndPassword.currentState?.validate() != true) {
      return;
    }

    final updated = await homePresenter.updateCommandData(
      newFixedCommandNumber: homePresenter.selectedCommand!,
      userPersonalizedCode: _personalizedCodeController.text.toInt(),
      password: _passwordController.text,
      printedProductsPresenter: printedProductsPresenter,
      peoples: homePresenter.selectedPeoples,
      sellerCode: homePresenter.selectedSeller?.SellersId.toString(),
    );

    if (updated) {
      Future.delayed(Duration.zero, () {
        showAlertMessage(
          context,
          R.string.msgUpdatedTableConfigurationsSuccess,
        );
        Navigator.of(context).pop();
      });
    }
  }

  Future<void> openOrBlock({
    required HomePresenter homePresenter,
    required bool liberate,
  }) async {
    if (_keyUserAndPassword.currentState?.validate() != true) {
      return;
    }

    final updated = await homePresenter.openOrBlockadeCommand(
      commandNumber: homePresenter.selectedCommand!.toInt(),
      isOpen: liberate,
    );

    if (updated) {
      Future.delayed(Duration.zero, () {
        showAlertMessage(
          context,
          liberate ? R.string.msgReleasesCommand : R.string.msgBlockedCommand,
          backgroundColor: Theme.of(context).secondaryHeaderColor,
        );
      });
    }
  }

  @override
  void initState() {
    super.initState();
    HomePresenter homePresenter = Provider.of(context, listen: false);

    homePresenter.updateSelectedCommand(homePresenter.commandNumber!.toInt());
  }

  @override
  void dispose() {
    super.dispose();

    _personalizedCodeController.dispose();
    _passwordController.dispose();
    _passwordFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    HomePresenter homePresenter = Provider.of(context, listen: false);
    PrintedProductsPresenter printedProductsPresenter =
        Provider.of(context, listen: false);

    final List<Widget> buttons = [
      UpdateConfigurationsButton(
        updateCommand: () async {
          await _updateCommandData(
            homePresenter,
            printedProductsPresenter,
          );
        },
      ),
      if (!homePresenter.isGeneratingVersionToRede) const ReserveTableButton(),
      ElevatedButton(
        onPressed: () async {
          await openOrBlock(homePresenter: homePresenter, liberate: true);
        },
        child: FittedBox(child: Text(R.string.liberateCommand)),
      ),
      ElevatedButton(
        onPressed: () async {
          await openOrBlock(homePresenter: homePresenter, liberate: false);
        },
        child: FittedBox(child: Text(R.string.blockCommand)),
      ),
      LogoutButton(
        userPassword: _passwordController,
        userPersonalizedCode: _personalizedCodeController,
        validationKey: _keyUserAndPassword,
        resetDropdownsErrors: () => _keyDropdowns.currentState?.reset(),
      ),
    ];

    return Scaffold(
      body: SingleChildScrollView(
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
                    userController: _personalizedCodeController,
                  ),
                  const SizedBox(height: 10),
                  PasswordInput(
                    passwordFocusNode: _passwordFocusNode,
                    passwordController: _passwordController,
                    updateCommandData: () async {
                      await _updateCommandData(
                        homePresenter,
                        printedProductsPresenter,
                      );
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: hasMinWidth(context) ? 3 : 2,
                  childAspectRatio: 5,
                  mainAxisSpacing: 5,
                  crossAxisSpacing: 5,
                ),
                itemCount: buttons.length,
                itemBuilder: (context, index) {
                  return buttons[index];
                },
              ),
            ),
            const UpdateMenuButton()
          ],
        ),
      ),
    );
  }
}
