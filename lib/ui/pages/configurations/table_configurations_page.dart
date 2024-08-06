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
  // ignore: unused_field
  int? _selectedPeopleNumbers;
  bool _isUpdatingCommandNumber = false;
  bool _isUpdatingPeopleNumbers = false;

  bool _isValidUserPasswordTableNumberAndPeopleNumbers() {
    bool? isValid = _key.currentState?.validate();

    if (isValid != true) {
      return false;
    } else {
      return true;
    }
  }

  Future<void> _updateCommandNumber(HomePresenter homePresenter) async {
    if (!_isValidUserPasswordTableNumberAndPeopleNumbers()) {
      return;
    }

    if (_selectedCommandNumber != null) {
      final updated = await homePresenter.updateFixedCommandNumber(
        newFixedCommandNumber: _selectedCommandNumber!,
        userPersonalizedCode: _personalizedCodeController.text.toInt(),
        password: _passwordController.text,
      );

      if (updated) {
        Future.delayed(Duration.zero, () {
          showAlertMessage(context, "Número da mesa alterado com sucesso");
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

    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _key,
          child: Column(
            children: [
              const SizedBox(height: 10),
              UpdateCommandNumber(
                isUpdatingCommandNumber: _isUpdatingCommandNumber,
                updateCommandNumber: (selectedCommandNumber) {
                  selectedCommandNumber.toString();
                  _selectedCommandNumber = selectedCommandNumber;
                },
              ),
              const SizedBox(height: 10),
              UpdatePeopleNumbers(
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
                changeIsUpdatingCommandNumber: () {
                  _isUpdatingCommandNumber = true;
                },
                updateCommandNumber: () async {
                  await _updateCommandNumber(homePresenter);
                },
              ),
              TextButton(
                onPressed: () async {
                  setState(() {
                    _isUpdatingCommandNumber = true;
                    _isUpdatingPeopleNumbers = true;
                  });
                  await _updateCommandNumber(homePresenter);
                },
                child: Text(
                  "Alterar mesa e qtd de pessoas",
                  style: TextStyle(
                    fontSize: getStringSize(context),
                  ),
                ),
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
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        showDialog(
                            context: context,
                            builder: (context) {
                              return const ReserveTable();
                            });
                      },
                      child: Text(
                        "Reservar mesa",
                        style: TextStyle(
                          fontSize: getStringSize(context),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
