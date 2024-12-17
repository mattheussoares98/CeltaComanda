import 'package:flutter/material.dart';

import '../../../components/components.dart';
import '../../../helpers/helpers.dart';

class CommandField extends StatelessWidget {
  final TextEditingController commandNumberController;
  const CommandField({
    required this.commandNumberController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("${R.string.minimumAbbreviated}: 1"),
              Text("${R.string.maximumAbbreviated}: 1000"),
            ],
          ),
        ),
        TextFormField(
          controller: commandNumberController,
          textAlign: TextAlign.center,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return R.string.msgWriteCommandNumber;
            } else if (int.tryParse(value) == null) {
              return R.string.msgInvalidNumber;
            } else if (value.toInt() > 1000 || value.toInt() == 0) {
              return R.string.msgInvalidNumber;
            }

            return null;
          },
          decoration: formFieldDecoration(
            context: context,
            hintText: R.string.commandNumber,
            labelText: R.string.commandNumber,
            errorText: null,
            prefixIcon: IconButton(
              color: Theme.of(context).primaryColor,
              onPressed: () {
                int? value = int.tryParse(commandNumberController.text);

                if (value != null && value > 1) {
                  commandNumberController.text = (value - 1).toString();
                }
              },
              icon: Icon(Icons.remove),
            ),
            suffixIcon: IconButton(
              color: Theme.of(context).primaryColor,
              onPressed: () {
                if (commandNumberController.text.isEmpty) {
                  commandNumberController.text = "1";
                  return;
                }

                int? value = int.tryParse(commandNumberController.text);

                if (value != null && value < 1000) {
                  commandNumberController.text = (value + 1).toString();
                }
              },
              icon: Icon(Icons.add),
            ),
          ),
        ),
      ],
    );
  }
}
