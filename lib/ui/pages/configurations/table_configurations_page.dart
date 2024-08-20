import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../ui/components/components.dart';
import '../../../../ui/helpers/helpers.dart';
import '../pages.dart';

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
  bool _isUpdatingCommandNumber = false;
  bool _isUpdatingPeopleNumbers = false;

  Future<void> _updateCommandNumber(
    HomePresenter homePresenter,
    PrintedProductsPresenter printedProductsPresenter,
  ) async {
    if (_key.currentState?.validate() != true) {
      return;
    }

    if (_selectedCommandNumber != null && _selectedPeopleNumbers != null) {
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
            R.string.msgUpdatedTableAndPeopleNumberSuccess,
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

    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _key,
          child: Column(
            children: [
              const SizedBox(height: 10),
              UpdateCommandNumberDropdown(
                isUpdatingCommandNumber: _isUpdatingCommandNumber,
                updateCommandNumber: (selectedCommandNumber) {
                  selectedCommandNumber.toString();
                  _selectedCommandNumber = selectedCommandNumber;
                },
              ),
              const SizedBox(height: 10),
              UpdatePeopleNumbersDropdown(
                isUpdatingPeopleNumbers: _isUpdatingPeopleNumbers,
                updatePeopleNumbers: (selectedPeopleNumbers) {
                  selectedPeopleNumbers.toString();
                  _selectedPeopleNumbers = selectedPeopleNumbers;
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
                updateCommandNumber: () async {
                  setState(() {
                    _isUpdatingCommandNumber = true;
                    _isUpdatingPeopleNumbers = true;
                  });
                  await _updateCommandNumber(
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
                      changeIsUpdatingCommandNumber: () {
                        _isUpdatingCommandNumber = false;
                      },
                    ),
                  ),
                  SizedBox(width: hasMinWidth(context) ? 10 : 1),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(hasMinWidth(context) ? 8.0 : 0),
                      child: ElevatedButton(
                        onPressed: () async {
                          FocusScope.of(context).unfocus();
                          setState(() {
                            _isUpdatingCommandNumber = true;
                            _isUpdatingPeopleNumbers = true;
                          });
                          await _updateCommandNumber(
                            homePresenter,
                            printedProductsPresenter,
                          );
                        },
                        child: FittedBox(
                          child: Padding(
                            padding:
                                EdgeInsets.all(hasMinWidth(context) ? 8.0 : 0),
                            child: Text(
                              R.string.updateTableNumber,
                              style: TextStyle(
                                fontSize: getStringSize(context),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: hasMinWidth(context) ? 10 : 1),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        showDialog(
                            context: context,
                            builder: (context) {
                              return const ReserveTable();
                            });
                      },
                      child: FittedBox(
                        child: Padding(
                          padding:
                              EdgeInsets.all(hasMinWidth(context) ? 8.0 : 0),
                          child: Text(
                            R.string.reserveTable,
                            style: TextStyle(
                              fontSize: getStringSize(context),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Row(
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
