import 'package:flutter/material.dart';

import '../../../../data/usecases/usecases.dart';

class UpdateCommandNumber extends StatefulWidget {
  const UpdateCommandNumber({super.key});

  @override
  State<UpdateCommandNumber> createState() => _UpdateCommandNumberState();
}

class _UpdateCommandNumberState extends State<UpdateCommandNumber> {
  final _userController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordFocusNode = FocusNode();

  int? _selectedCommandNumber;
  final _cameraBarcodeScanner = CameraBarcodeScanner();

  @override
  void dispose() {
    super.dispose();

    _userController.dispose();
    _passwordController.dispose();
    _passwordFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          DropdownButtonFormField(
            decoration: const InputDecoration(
              hintText: "Número da mesa",
            ),
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
            decoration: const InputDecoration(
              hintText: "Usuário",
              labelText: "Usuário",
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            focusNode: _passwordFocusNode,
            controller: _passwordController,
            obscureText: true,
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
              _selectedCommandNumber = _selectedCommandNumber;
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
    );
  }
}
