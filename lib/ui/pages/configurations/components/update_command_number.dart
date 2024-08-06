import 'package:flutter/material.dart';

class UpdateCommandNumber extends StatelessWidget {
  final bool isUpdatingCommandNumber;
  final Function(int value) updateCommandNumber;
  const UpdateCommandNumber({
    required this.isUpdatingCommandNumber,
    required this.updateCommandNumber,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<int>(
      validator: (value) {
        if (!isUpdatingCommandNumber) {
          return null;
        } else if (value == null) {
          return "Selecione a comanda";
        }

        return null;
      },
      decoration: const InputDecoration(
        hintText: "Número da mesa",
        labelText: "Número da mesa",
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
                updateCommandNumber(e + 1);
              },
              child: Text(
                (e + 1).toString(),
              ),
            ),
          )
          .toList(),
      onChanged: (value) {
        updateCommandNumber(value ?? 0 + 1);
      },
    );
  }
}
