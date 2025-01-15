import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../components/components.dart';
import '../../../helpers/helpers.dart';

class EnterpriseNameInput extends StatelessWidget {
  final TextEditingController enterpriseNameController;
  final FocusNode navsFocusNode;
  const EnterpriseNameInput({
    required this.enterpriseNameController,
    required this.navsFocusNode,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: enterpriseNameController,
      keyboardType: TextInputType.text,
      inputFormatters: [
        LengthLimitingTextInputFormatter(20),
      ],
      onFieldSubmitted: (_) {
        navsFocusNode.requestFocus();
      },
      decoration: formFieldDecoration(
        context: context,
        hintText: R.string.enterprise,
        labelText: R.string.enterprise,
        errorText: null,
        suffixIcon: Icon(Icons.business),
        fontSize: 14,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return R.string.msgWriteName;
        }
        return null;
      },
    );
  }
}
