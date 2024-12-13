import 'package:flutter/material.dart';

import '../../../../helpers/helpers.dart';

class SelectTableDropdown extends StatelessWidget {
  final void Function(int? value) updateSelectedCommand;
  final GlobalKey<FormState> formKey;
  final int? selectedCommandInDropDown;
  const SelectTableDropdown({
    required this.updateSelectedCommand,
    required this.formKey,
    required this.selectedCommandInDropDown,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: DropdownButtonFormField(
        isExpanded: true,
        alignment: Alignment.center,
        validator: (value) {
          if (value == null) {
            return R.string.msgSelectCommand;
          }

          return null;
        },
        hint: Text(selectedCommandInDropDown == null
            ? R.string.msgSelectTable
            : "${R.string.table} $selectedCommandInDropDown"),
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: StringSize.size,
          color: Colors.black,
        ),
        items: List<int>.generate(
          100,
          (int index) => index++,
          growable: true,
        )
            .map(
              (e) => DropdownMenuItem(
                value: e + 1,
                onTap: () async {},
                child: Center(
                  child: Text(
                    (e + 1).toString(),
                  ),
                ),
              ),
            )
            .toList(),
        onChanged: (value) async {
          formKey.currentState?.validate();

          updateSelectedCommand(value);
        },
      ),
    );
  }
}
