import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../helpers/helpers.dart';
import '../../../pages.dart';

class UpdatePeopleNumbersDropdown extends StatelessWidget {
  final bool validate;
  final Function(int value) updatePeopleNumbers;
  const UpdatePeopleNumbersDropdown({
    required this.validate,
    required this.updatePeopleNumbers,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    HomePresenter homePresenter = Provider.of(context, listen: false);

    return DropdownButtonFormField<int>(
      value: homePresenter.peoples,
      validator: (value) {
        if (!validate) {
          return null;
        } else if (value == null) {
          return R.string.msgSelectPeopleNumbers;
        }

        return null;
      },
      decoration: InputDecoration(
        hintText: R.string.peopleQuantity,
        labelText: R.string.peopleQuantity,
      ),
      items: List<int>.generate(
        50,
        (int index) => index++,
        growable: true,
      )
          .map(
            (e) => DropdownMenuItem(
              value: e + 1,
              onTap: () {
                updatePeopleNumbers(e + 1);
              },
              child: Text(
                (e + 1).toString(),
              ),
            ),
          )
          .toList(),
      onChanged: (value) {
        updatePeopleNumbers(value ?? 0 + 1);
      },
    );
  }
}
