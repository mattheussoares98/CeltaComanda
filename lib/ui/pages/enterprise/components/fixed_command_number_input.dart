import 'package:flutter/material.dart';

import '../../../helpers/helpers.dart';

class FixedCommandNumberInput extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final void Function() validateEnterprise;
  final TextEditingController commandNumberController;
  const FixedCommandNumberInput({
    required this.formKey,
    required this.validateEnterprise,
    required this.commandNumberController,
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
          onFieldSubmitted: (_) async {
            validateEnterprise();
          },
          onChanged: (String newValue) {
            commandNumberController.text = newValue;
          },
          validator: (value) {
            if (value == null) {
              return R.string.msgWriteTableNumber;
            } else if (int.tryParse(value) == null) {
              return R.string.msgInvalidNumber;
            } else if (int.parse(value) == 0) {
              return R.string.msgInvalidNumber;
            } else {
              return null;
            }
          },
          decoration: InputDecoration(
            label: Text(R.string.msgTableNumber),
            hintText: R.string.msgTableNumber,
            counterText: "",
          ),
        ),
      ),
    );
  }
}
