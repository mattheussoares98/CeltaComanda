import 'package:clean_celta_mobile/ui/components/components.dart';
import 'package:flutter/material.dart';

import '../../../../helpers/helpers.dart';

class InsertCommandNumber extends StatelessWidget {
  final GlobalKey<FormState> commandNumberKey;
  final TextEditingController commandNumberController;
  const InsertCommandNumber({
    required this.commandNumberKey,
    required this.commandNumberController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: SizedBox()),
        Expanded(
          child: Form(
            key: commandNumberKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: TextFormField(
              autofocus: true,
              controller: commandNumberController,
              keyboardType: TextInputType.number,
              maxLength: 3,
              textAlign: TextAlign.center,
              decoration: formFieldDecoration(
                showCounterText: false,
                context: context,
                hintText: R.string.commandNumber,
                labelText: R.string.commandNumber,
                errorText: null,
              ),
              validator: (value) {
                if (int.tryParse(value!) == null) {
                  return R.string.msgInvalidNumber;
                }
                return null;
              },
            ),
          ),
        ),
        const Expanded(child: SizedBox()),
      ],
    );
  }
}
