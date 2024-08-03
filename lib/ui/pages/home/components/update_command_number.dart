import 'package:flutter/material.dart';

class UpdateCommandNumber extends StatelessWidget {
  const UpdateCommandNumber({super.key});

  static int? _selectedCommandNumber;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
          TextFormField(
            decoration: const InputDecoration(
              hintText: "Usuário",
              labelText: "Usuário",
            ),
          ),
          TextFormField(
            decoration: const InputDecoration(
              suffixIcon: Icon(Icons.camera_alt),
              hintText: "Senha",
              labelText: "Senha",
            ),
          ),
          TextButton(
            onPressed: () async {
              _selectedCommandNumber = _selectedCommandNumber;
            },
            child: const Text(
              "Alterar mesa",
            ),
          ),
        ],
      ),
    );
  }
}
