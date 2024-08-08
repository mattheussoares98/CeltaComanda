import 'package:flutter/material.dart';

import '../../../helpers/helpers.dart';

class UpdatePeopleNumbers extends StatelessWidget {
  final bool isUpdatingPeopleNumbers;
  final Function(int value) updatePeopleNumbers;
  const UpdatePeopleNumbers({
    required this.isUpdatingPeopleNumbers,
    required this.updatePeopleNumbers,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<int>(
      validator: (value) {
        if (!isUpdatingPeopleNumbers) {
          return null;
        } else if (value == null) {
          return R.string.msgSelectPeopleNumbers;
        }

        return null;
      },
      decoration: const InputDecoration(
        hintText: "Quantidade de pessoas",
        labelText: "Quantidade de pessoas",
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
