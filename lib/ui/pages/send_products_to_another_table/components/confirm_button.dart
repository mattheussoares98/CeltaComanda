import 'package:flutter/material.dart';

import '../../../helpers/helpers.dart';

class ConfirmButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  const ConfirmButton({
    required this.formKey,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: ElevatedButton(
        onPressed: () {
          bool? isValid = formKey.currentState?.validate();
        },
        child: Text(
          R.string.confirm,
        ),
      ),
    );
  }
}
