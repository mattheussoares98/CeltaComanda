import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../helpers/helpers.dart';
import '../../../pages.dart';

class UpdateCommandNumberDropdown extends StatelessWidget {
  const UpdateCommandNumberDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    HomePresenter homePresenter = Provider.of(context, listen: false);
    ConfigurationsPresenter configurationsPresenter =
        Provider.of(context, listen: false);

    return DropdownButtonFormField<int>(
      isExpanded: true,
      value: homePresenter.commandEntity!.commandNumber?.toInt(),
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
                configurationsPresenter.updateSelectedCommand(e + 1);
              },
              child: Text(
                (e + 1).toString(),
              ),
            ),
          )
          .toList(),
      onChanged: (value) {
        configurationsPresenter.updateSelectedCommand(value ?? 0 + 1);
      },
    );
  }
}
