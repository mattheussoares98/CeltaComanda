import 'package:flutter/material.dart';

import '../../../helpers/helpers.dart';

class SelectTableDropDown extends StatelessWidget {
  final int? selectedCommandInDropDown;
  final void Function(int? value) updateSelectedCommandInDropDown;
  final String hintText;
  final String? Function(int?)? validator;
  const SelectTableDropDown({
    required this.selectedCommandInDropDown,
    required this.updateSelectedCommandInDropDown,
    required this.hintText,
    required this.validator,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final double stringSize = getStringSize(context);

    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: DropdownButtonFormField(
              validator: validator,
              isExpanded: true,
              alignment: Alignment.center,
              hint: Text(selectedCommandInDropDown == null
                  ? hintText
                  : "${R.string.table} $selectedCommandInDropDown"),
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: stringSize,
                  color: Colors.black),
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
                updateSelectedCommandInDropDown(value);
              },
            ),
          ),
        ),
      ],
    );
  }
}
