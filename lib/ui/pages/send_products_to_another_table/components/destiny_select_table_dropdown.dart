import 'package:flutter/material.dart';

import '../../../helpers/helpers.dart';
import 'components.dart';

class DestinySelectTableDropdown extends StatelessWidget {
  final int? selectedOriginCommand;
  final int? selectedDestinyCommand;
  final void Function(int?) updateSelectedCommandInDropDown;
  const DestinySelectTableDropdown({
    required this.selectedDestinyCommand,
    required this.selectedOriginCommand,
    required this.updateSelectedCommandInDropDown,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("" + "destiny"),
        SelectTableDropDown(
          validator: (value) {
            if (value == null || selectedDestinyCommand == null) {
              return R.string.msgSelectCommand;
            } else if(selectedOriginCommand == selectedDestinyCommand) {
              return "cant select the same command number" + "";
            }
            return null;
          },
          hintText: R.string.msgSelectCommand,
          selectedCommandInDropDown: selectedDestinyCommand,
          updateSelectedCommandInDropDown: updateSelectedCommandInDropDown,
        ),
      ],
    );
  }
}
