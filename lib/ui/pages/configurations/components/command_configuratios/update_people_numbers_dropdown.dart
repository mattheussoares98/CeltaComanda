import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../helpers/helpers.dart';
import '../../../pages.dart';

class UpdatePeopleNumbersDropdown extends StatelessWidget {
  const UpdatePeopleNumbersDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    HomePresenter homePresenter = Provider.of(context, listen: false);

    return DropdownButtonFormField<int>(
      isExpanded: true,
      value: homePresenter.selectedPeoples,
      validator: (value) {
        if (value == null) {
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
                homePresenter.updateSelectedPeoples(e + 1);
              },
              child: Text(
                (e + 1).toString(),
              ),
            ),
          )
          .toList(),
      onChanged: (value) {
        homePresenter.updateSelectedPeoples(value ?? 0 + 1);
      },
    );
  }
}
