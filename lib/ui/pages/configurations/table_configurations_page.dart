import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../ui/components/components.dart';
import '../../../../ui/helpers/helpers.dart';
import '../../../data/usecases/usecases.dart';
import '../pages.dart';

class TableConfigurationsPage extends StatefulWidget {
  const TableConfigurationsPage({super.key});

  @override
  State<TableConfigurationsPage> createState() => _TableConfigurationsPageState();
}

class _TableConfigurationsPageState extends State<TableConfigurationsPage> {
  final _userController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordFocusNode = FocusNode();
  final _key = GlobalKey<FormState>();

  int? _selectedCommandNumber;
  final _cameraBarcodeScanner = CameraBarcodeScanner();
  bool _isUpdatingCommandNumber = false;

  bool _isValidUserAndPassword() {
    bool? isValid = _key.currentState?.validate();

    if (isValid != true) {
      return false;
    } else {
      return true;
    }
  }

  Future<void> _updateCommandNumber(HomePresenter homePresenter) async {
    if (!_isValidUserAndPassword()) {
      return;
    }

    if (_selectedCommandNumber != null) {
      final updated = await homePresenter.updateFixedCommandNumber(
        newFixedCommandNumber: _selectedCommandNumber!,
        userPersonalizedCode: _userController.text.toInt(),
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

    _userController.dispose();
    _passwordController.dispose();
    _passwordFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    HomePresenter homePresenter = Provider.of(context, listen: false);
    PrintedProductsPresenter printedProductsPresenter =
        Provider.of(context, listen: false);
    CartPresenter cartPresenter = Provider.of(context, listen: false);
    MenuPresenter menuPresenter = Provider.of(context, listen: false);

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
              TextFormField(
                onFieldSubmitted: (_) {
                  _passwordFocusNode.requestFocus();
                },
                controller: _userController,
                validator: (value) {
                  if (value?.isEmpty == true) {
                    return "Digite o código do usuário";
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: "Código do usuário",
                  labelText: "Código do usuário",
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                focusNode: _passwordFocusNode,
                controller: _passwordController,
                obscureText: true,
                validator: (value) {
                  if (value?.isEmpty == true) {
                    return "Digite a senha";
                  }
                  return null;
                },
                onFieldSubmitted: (_) async {
                  _isUpdatingCommandNumber = true;
                  await _updateCommandNumber(homePresenter);
                },
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: () async {
                      final password = await _cameraBarcodeScanner.read();
                      if (password.isNotEmpty) {
                        _passwordController.text = password;
                      }
                    },
                    icon: const Icon(Icons.camera_alt),
                  ),
                  hintText: "Senha",
                  labelText: "Senha",
                ),
              ),
              TextButton(
                onPressed: () async {
                  _isUpdatingCommandNumber = true;
                  await _updateCommandNumber(homePresenter);
                },
                child: Text(
                  "Alterar mesa",
                  style: TextStyle(
                    fontSize: getStringSize(context),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () async {
                        _isUpdatingCommandNumber = false;
                        if (_isValidUserAndPassword()) {
                          if (cartPresenter.cartProducts.isNotEmpty) {
                            notificationDialog(
                                context: context,
                                titleMessage: "Limpar carrinho",
                                content: const Text(
                                    "Ao fazer o logout, o carrinho será limpo!"),
                                onPress: () async {
                                  if (_isValidUserAndPassword()) {
                                    cartPresenter.clearCart();
                                    await homePresenter.goToSplashPage(
                                      printedProductsPresenter:
                                          printedProductsPresenter,
                                      cartPresenter: cartPresenter,
                                      menuPresenter: menuPresenter,
                                    );
                                  }
                                });
                          } else {
                            await homePresenter.goToSplashPage(
                              printedProductsPresenter:
                                  printedProductsPresenter,
                              cartPresenter: cartPresenter,
                              menuPresenter: menuPresenter,
                            );
                          }
                        }
                      },
                      child: FittedBox(
                        child: Text(
                          "Fazer logout",
                          style: TextStyle(
                            fontSize: getStringSize(context),
                          ),
                        ),
                      ),
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
