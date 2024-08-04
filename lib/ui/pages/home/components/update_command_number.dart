import 'package:clean_celta_mobile/ui/helpers/convert/convert.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../data/usecases/usecases.dart';
import '../../pages.dart';

class UpdateCommandNumber extends StatefulWidget {
  const UpdateCommandNumber({super.key});

  @override
  State<UpdateCommandNumber> createState() => _UpdateCommandNumberState();
}

class _UpdateCommandNumberState extends State<UpdateCommandNumber> {
  final _userController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordFocusNode = FocusNode();
  final _key = GlobalKey<FormState>();

  int? _selectedCommandNumber;
  final _cameraBarcodeScanner = CameraBarcodeScanner();

  Future<void> _updateCommandNumber(HomePresenter homePresenter) async {
    bool? isValid = _key.currentState?.validate();

    if (isValid != true) {
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

    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _key,
          child: Column(
            children: [
              const SizedBox(height: 10),
              DropdownButtonFormField<int>(
                validator: (value) {
                  if (value == null) {
                    return "Selecione a comanda";
                  }

                  return null;
                },
                decoration: const InputDecoration(
                    hintText: "Número da mesa", labelText: "Número da mesa"),
                items: List<int>.generate(
                  100,
                  (int index) => index++,
                  growable: true,
                )
                    .map(
                      (e) => DropdownMenuItem(
                        value: e + 1,
                        onTap: () {
                          _selectedCommandNumber = e + 1;
                        },
                        child: Text(
                          (e + 1).toString(),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  _selectedCommandNumber = value ?? 0 + 1;
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
                  await _updateCommandNumber(homePresenter);
                },
                child: const Text(
                  "Confirmar",
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      "Reservar mesa",
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
