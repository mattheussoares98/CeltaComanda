import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

import '../../../../ui/pages/pages.dart';

class FixedCommandNumberInput extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final CommandViewModel commandViewModel;
  final void Function() validateEnterprise;
  const FixedCommandNumberInput({
    required this.formKey,
    required this.commandViewModel,
    required this.validateEnterprise,
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
          onFieldSubmitted: (_) async {
            validateEnterprise();
          }, //implementar
          onChanged: (String? newValue) {
            enterpriseValidationPresenter.updateCommandNumber(
              newCommandValue: newValue?.isEmpty == true ? null : newValue,
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
