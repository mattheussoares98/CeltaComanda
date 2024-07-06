import 'package:clean_celta_mobile/ui/pages/pages.dart';
import 'package:flutter/material.dart';

class FixedCommandNumberInput extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final CommandViewModel commandViewModel;
  const FixedCommandNumberInput({
    required this.formKey,
    required this.commandViewModel,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Form(
        key: formKey,
        child: TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          autofocus: true,
          keyboardType: TextInputType.number,
          maxLength: 3,
          onFieldSubmitted: null, //implementar
          onChanged: (String? newValue) {
            //criar update command number
          },
          validator: (value) {
            if (value == null) {
              return "Digite o número da mesa";
            } else if (int.tryParse(value) == null) {
              return "Número inválido";
            } else if (int.parse(value) == 0) {
              return "Número inválido";
            } else {
              return null;
            }
          },
          decoration: const InputDecoration(
            label: Text("Número da mesa"),
            hintText: "Número da mesa",
            counterText: "",
          ),
        ),
      ),
    );
  }
}
