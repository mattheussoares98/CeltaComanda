import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../helpers/helpers.dart';
import '../../../pages.dart';

class UpdateCommandNumberDropdown extends StatelessWidget {
  final Function(int value) updateCommandNumber;
  const UpdateCommandNumberDropdown({
    required this.updateCommandNumber,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    HomePresenter homePresenter = Provider.of(context, listen: false);

    return DropdownButtonFormField<int>(
      value: homePresenter.commandNumber?.toInt(),
      validator: (value) {
        if (value == null) {
          return R.string.msgSelectCommand;
        }

        return null;
      },
      decoration: InputDecoration(
        hintText: R.string.msgTableNumber,
        labelText: R.string.msgTableNumber,
      ),
      items: List<int>.generate(
        100,
        (int index) => index++,
        growable: true,
      )
          .map(
            (e) => DropdownMenuItem(
              value: e + 1,
              onTap: () {
                updateCommandNumber(e + 1);
              },
              child: Text(
                (e + 1).toString(),
              ),
            ),
          )
          .toList(),
      onChanged: (value) {
        updateCommandNumber(value ?? 0 + 1);
      },
    );
  }
}
