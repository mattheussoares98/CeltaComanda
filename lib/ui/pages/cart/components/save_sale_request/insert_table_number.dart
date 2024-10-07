import 'package:flutter/material.dart';

import '../../../../helpers/helpers.dart';

class InsertTableNumber extends StatelessWidget {
  final GlobalKey<FormState> tableKey;
  final TextEditingController tableNumberController;
  const InsertTableNumber({
    required this.tableKey,
    required this.tableNumberController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: SizedBox()),
        Expanded(
          child: Form(
            key: tableKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: TextFormField(
              autofocus: true,
              controller: tableNumberController,
              keyboardType: TextInputType.number,
              maxLength: 4,
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                counterText: "",
              ),
              validator: (value) {
                if (int.tryParse(value!) == null) {
                  return R.string.msgInvalidNumber;
                }
                return null;
              },
            ),
          ),
        ),
        const Expanded(child: SizedBox()),
      ],
    );
  }
}
