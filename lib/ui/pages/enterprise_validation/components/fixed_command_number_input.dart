import 'package:clean_celta_mobile/ui/pages/pages.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    EnterpriseValidationPresenter enterpriseValidationPresenter =
        Provider.of(context, listen: false);
    HomePresenter homePresenter = Provider.of(context, listen: false);

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
            enterpriseValidationPresenter.updateCommandNumber(
              newCommandValue: newValue ?? "",
              homePresenter: homePresenter,
            );
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
