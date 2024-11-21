import 'package:flutter/material.dart';

import '../../../components/components.dart';
import '../../../helpers/helpers.dart';

class EmailField extends StatelessWidget {
  final TextEditingController emailController;
  final FocusNode passwordFocusNode;
  const EmailField({
    required this.emailController,
    required this.passwordFocusNode,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      maxLength: 30,
      decoration: formFieldDecoration(
        showCounterText: false,
        context: context,
        hintText: R.string.email,
        labelText: R.string.email,
        errorText: null,
      ),
      onFieldSubmitted: (_) {
        passwordFocusNode.requestFocus();
      },
    );
  }
}
