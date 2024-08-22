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
    MenuPresenter menuPresenter = Provider.of(context, listen: false);
    CartPresenter cartPresenter = Provider.of(context, listen: false);
    ExpansibleGroupFromProductPresenter expansibleGroupFromProductPresenter =
        Provider.of(context, listen: false);

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
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: LogoutButton(
                      userPassword: _passwordController,
                      userPersonalizedCode: _personalizedCodeController,
                      validationKey: _key,
                      updateIsDoingLogout: () {
                        setState(() {
                          _isDoingLogout = true;
                        });
                      },
                    ),
                  ),
                  SizedBox(width: hasMinWidth(context) ? 10 : 1),
                  Expanded(
                    child: UpdateConfigurationsButton(
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
                  ),
                  SizedBox(width: hasMinWidth(context) ? 10 : 1),
                  const Expanded(
                    child: ReserveTableButton(),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(
                      label: Text(R.string.updateMenu),
                      icon: Icon(
                        Icons.refresh_outlined,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      onPressed: () async {
                        Navigator.of(context).pop();
                        await homePresenter.loadCommandData(
                          menuPresenter: menuPresenter,
                          printedProductsPresenter: printedProductsPresenter,
                          cartPresenter: cartPresenter,
                          expansibleGroupFromProductPresenter:
                              expansibleGroupFromProductPresenter,
                          homePresenter: homePresenter,
                        );
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            R.string.close.toUpperCase(),
                            style: TextStyle(
                              fontSize: getStringSize(context),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
