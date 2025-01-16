import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../components/components.dart';
import '../../../helpers/helpers.dart';

class ConcentratorUrlInput extends StatelessWidget {
  final TextEditingController concentratorController;
  final FocusNode concentratorFocusNode;
  final FocusNode ccsFocusNode;
  const ConcentratorUrlInput({
    required this.concentratorController,
    required this.concentratorFocusNode,
    required this.ccsFocusNode,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: TextFormField(
        focusNode: concentratorFocusNode,
        controller: concentratorController,
        inputFormatters: [
          LengthLimitingTextInputFormatter(70),
        ],
        decoration: formFieldDecoration(
          context: context,
          hintText: R.string.concentratorUrl,
          labelText: R.string.concentratorUrl,
          errorText: null,
          fontSize: 14,
          suffixIcon: Icon(Icons.public, color: Theme.of(context).primaryColor),
        ),
        onFieldSubmitted: (_) {
          ccsFocusNode.requestFocus();
        },
        keyboardType: TextInputType.url,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return R.string.concentratorUrl;
          }
          return null;
        },
      ),
    );
  }
}
