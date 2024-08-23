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

  int? _selectedCommandNumber;
  int? _selectedPeopleNumbers;
  SellersViewModel? _selectedSeller;

  Future<void> _updateCommandData(
    HomePresenter homePresenter,
    PrintedProductsPresenter printedProductsPresenter,
  ) async {
    FocusScope.of(context).unfocus();

    if (_keyDropdowns.currentState?.validate() != true ||
        _keyUserAndPassword.currentState?.validate() != true) {
      return;
    }

    if (_selectedCommandNumber == null && homePresenter.commandNumber != null) {
      _selectedCommandNumber = homePresenter.commandNumber!.toInt();
    }

    if (_selectedCommandNumber != null &&
        _selectedPeopleNumbers != null &&
        _selectedSeller != null) {
      final updated = await homePresenter.updateCommandData(
        newFixedCommandNumber: _selectedCommandNumber!,
        userPersonalizedCode: _personalizedCodeController.text.toInt(),
        password: _passwordController.text,
        printedProductsPresenter: printedProductsPresenter,
        peoples: _selectedPeopleNumbers,
        sellerCode: _selectedSeller?.SellersId.toString(),
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
  }

  Future<void> openOrBlock({
    required HomePresenter homePresenter,
    required bool liberate,
  }) async {
    if (_keyUserAndPassword.currentState?.validate() != true) {
      return;
    }

    if (_selectedCommandNumber == null && homePresenter.commandNumber != null) {
      _selectedCommandNumber = homePresenter.commandNumber!.toInt();
    }

    if (_selectedCommandNumber != null) {
      final updated = await homePresenter.openOrBlockadeCommand(
        commandNumber: _selectedCommandNumber!,
        isOpen: liberate,
      );

      if (updated) {
        Future.delayed(Duration.zero, () {
          showAlertMessage(
            context,
            liberate ? "helper to liberate" : "helper to block",
            backgroundColor: Theme.of(context).secondaryHeaderColor,
          );
        });
      }
    }
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
      LogoutButton(
        userPassword: _passwordController,
        userPersonalizedCode: _personalizedCodeController,
        validationKey: _keyUserAndPassword,
        resetDropdownsErrors: () => _keyDropdowns.currentState?.reset(),
      ),
      UpdateConfigurationsButton(
        updateCommand: () async {
          await _updateCommandData(
            homePresenter,
            printedProductsPresenter,
          );
        },
      ),
      const ReserveTableButton(),
      ElevatedButton(
        onPressed: () async {
          await openOrBlock(homePresenter: homePresenter, liberate: true);
        },
        child: Text(R.string.msgReleasesCommand),
      ),
      ElevatedButton(
        onPressed: () async {
          await openOrBlock(homePresenter: homePresenter, liberate: false);
        },
        child: Text(R.string.msgBlockedCommand),
      ),
    ];

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Form(
              key: _keyDropdowns,
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  UpdateCommandNumberDropdown(
                    updateCommandNumber: (selectedCommandNumber) {
                      _selectedCommandNumber = selectedCommandNumber;
                    },
                  ),
                  const SizedBox(height: 10),
                  UpdatePeopleNumbersDropdown(
                    updatePeopleNumbers: (selectedPeopleNumbers) {
                      _selectedPeopleNumbers = selectedPeopleNumbers;
                    },
                  ),
                  const SizedBox(height: 10),
                  UpdateSellerDropdown(
                    updateSelectedSeller: (selectedSeller) {
                      _selectedSeller = selectedSeller;
                    },
                  ),
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
