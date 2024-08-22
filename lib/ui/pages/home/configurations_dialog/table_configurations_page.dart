import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../ui/components/components.dart';
import '../../../../../ui/helpers/helpers.dart';
import '../../pages.dart';
import 'configurations_dialog.dart';

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
  final _key = GlobalKey<FormState>();

  int? _selectedCommandNumber;
  int? _selectedPeopleNumbers;
  SellersViewModel? _selectedSeller;
  bool _isDoingLogout = true;

  Future<void> _updateCommandData(
    HomePresenter homePresenter,
    PrintedProductsPresenter printedProductsPresenter,
  ) async {
    FocusScope.of(context).unfocus();

    if (_key.currentState?.validate() != true) {
      return;
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
        validationKey: _key,
        updateIsDoingLogout: () {
          setState(() {
            _isDoingLogout = true;
          });
        },
      ),
      UpdateConfigurationsButton(
        updateCommand: () async {
          setState(() {
            _isDoingLogout = false;
          });

          await _updateCommandData(
            homePresenter,
            printedProductsPresenter,
          );
        },
      ),
      const ReserveTableButton(),
    ];

    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _key,
          child: Column(
            children: [
              const SizedBox(height: 10),
              UpdateCommandNumberDropdown(
                validate: !_isDoingLogout,
                updateCommandNumber: (selectedCommandNumber) {
                  _selectedCommandNumber = selectedCommandNumber;
                },
              ),
              const SizedBox(height: 10),
              UpdatePeopleNumbersDropdown(
                validate: !_isDoingLogout,
                updatePeopleNumbers: (selectedPeopleNumbers) {
                  _selectedPeopleNumbers = selectedPeopleNumbers;
                },
              ),
              const SizedBox(height: 10),
              UpdateSellerDropdown(
                validate: !_isDoingLogout,
                updateSelectedSeller: (selectedSeller) {
                  _selectedSeller = selectedSeller;
                },
              ),
              const SizedBox(height: 10),
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
      ),
    );
  }
}
