import 'package:flutter/material.dart';

import '../../../../helpers/helpers.dart';

class OldPersonalizedCodeDropdown extends StatelessWidget {
  final int? oldPersonalizedCode;
  final void Function(int? value) updateOldPersonalizedCode;
  const OldPersonalizedCodeDropdown({
    required this.oldPersonalizedCode,
    required this.updateOldPersonalizedCode,
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
        }

        return null;
      },
      decoration: InputDecoration(
        prefixText: R.string.msgOldTable,
        hintText: R.string.msgOldTable,
      ),
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: getStringSize(context),
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
        updateOldPersonalizedCode(value);
      },
    );
  }
}
