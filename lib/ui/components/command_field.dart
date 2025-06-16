import 'package:flutter/material.dart';

import 'components.dart';
import '../helpers/helpers.dart';

class CommandField extends StatelessWidget {
  final TextEditingController commandNumberController;
  final String? hintText;
  final String? labelText;
  final bool? validateField;
  final FocusNode? focusNode;
  final Future<void> Function()? loadData;
  final void Function(String)? onFieldSubmitted;
  const CommandField({
    required this.commandNumberController,
    this.hintText,
    this.labelText,
    this.validateField = true,
    this.focusNode,
    this.loadData,
    this.onFieldSubmitted,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text("${R.string.minimumAbbreviated}: 1")),
                    Expanded(
                      child: Text(
                        "${R.string.maximumAbbreviated}: 1000",
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
              ),
              TextFormField(
                controller: commandNumberController,
                textAlign: TextAlign.center,
                focusNode: focusNode,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                keyboardType: TextInputType.numberWithOptions(decimal: false),
                onTap: () {
                  commandNumberController.selection = TextSelection(
                    baseOffset: 0,
                    extentOffset: commandNumberController.text.length,
                  );
                },
                onFieldSubmitted: (any) async {
                  if (loadData != null) {
                    await loadData!();
                  }

                  if (onFieldSubmitted != null) {
                    onFieldSubmitted!(any);
                  }
                },
                validator: (value) {
                  if (validateField == false) {
                    return null;
                  } else if (value == null || value.isEmpty) {
                    return R.string.msgWriteCommandNumber;
                  } else if (int.tryParse(value) == null) {
                    return R.string.msgInvalidNumber;
                  } else if (value.toInt() > 1000 || value.toInt() == 0) {
                    return R.string.msgInvalidNumber;
                  } else if (value.toInt() < 1) {
                    return R.string.msgInvalidNumber;
                  }

                  return null;
                },
                decoration: formFieldDecoration(
                  context: context,
                  hintText: hintText ?? R.string.commandNumber,
                  labelText: labelText ?? R.string.commandNumber,
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
          ),
        ),
        if (loadData != null)
          IconButton(
            onPressed: () async {
              await loadData!();
            },
            icon: Row(
              children: [
                Icon(Icons.search),
                if (ScreenSize.hasMinWidth)
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text(R.string.search),
                  )
              ],
            ),
          ),
      ],
    );
  }
}
