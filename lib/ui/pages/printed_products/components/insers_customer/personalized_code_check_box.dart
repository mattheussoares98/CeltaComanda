import 'package:flutter/material.dart';

import '../../../../helpers/helpers.dart';

class PersonalizedCodeCheckBox extends StatelessWidget {
  final bool searchByPersonalizedCode;
  final void Function(bool?)? updateValue;
  const PersonalizedCodeCheckBox({
    super.key,
    required this.searchByPersonalizedCode,
    required this.updateValue,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: CheckboxMenuButton(
        value: searchByPersonalizedCode,
        onChanged: updateValue,
        child: Text(R.string.searchByPersonalizedCode),
      ),
    );
  }
}
