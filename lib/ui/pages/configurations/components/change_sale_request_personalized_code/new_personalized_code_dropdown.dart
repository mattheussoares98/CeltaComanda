import 'package:flutter/material.dart';

import '../../../../helpers/helpers.dart';

class NewPersonalizedCodeDropdown extends StatelessWidget {
  final int? newPersonalizedCode;
  final int? oldPersonalizedCode;
  final void Function(int? value) updateNewPersonalizedCode;
  const NewPersonalizedCodeDropdown({
    required this.newPersonalizedCode,
    required this.oldPersonalizedCode,
    required this.updateNewPersonalizedCode,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      isExpanded: true,
      alignment: Alignment.center,
      validator: (value) {
        if (value == null) {
          return R.string.msgSelectCommand;
        } else if (newPersonalizedCode == oldPersonalizedCode) {
          return R.string.msgInvalidNumber;
        }

        return null;
      },
      decoration: InputDecoration(
        prefixText: R.string.msgNewTable,
        hintText: R.string.msgNewTable,
      ),
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
        updateNewPersonalizedCode(value);
      },
    );
  }
}
