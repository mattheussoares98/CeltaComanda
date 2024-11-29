import 'package:flutter/material.dart';

import '../../../helpers/helpers.dart';
import 'components.dart';

class OriginSelectTableDropdown extends StatelessWidget {
  final int? selectedOriginCommand;
  final void Function(int?) updateSelectedCommandInDropDown;
  const OriginSelectTableDropdown({
    required this.selectedOriginCommand,
    required this.updateSelectedCommandInDropDown,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(R.string.originTable),
        SelectTableDropDown(
          validator: (value) {
            if (value == null || selectedOriginCommand == null) {
              return R.string.msgSelectCommand;
            }
            return null;
          },
          hintText: R.string.msgSelectCommand,
          selectedCommandInDropDown: selectedOriginCommand,
          updateSelectedCommandInDropDown: updateSelectedCommandInDropDown,
        ),
      ],
    );
  }
}
