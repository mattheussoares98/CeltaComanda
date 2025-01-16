import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../components/components.dart';
import '../../../helpers/helpers.dart';

class CcsUrlInput extends StatelessWidget {
  final TextEditingController ccsController;
  final FocusNode ccsFocusNode;
  final FocusNode enterpriseIdFocusNode;
  const CcsUrlInput({
    required this.ccsController,
    required this.ccsFocusNode,
    required this.enterpriseIdFocusNode,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: TextFormField(
        controller: ccsController,
        focusNode: ccsFocusNode,
        inputFormatters: [
          LengthLimitingTextInputFormatter(70),
        ],
        decoration: formFieldDecoration(
          context: context,
          hintText: R.string.ccsUrl,
          labelText: R.string.ccsUrl,
          errorText: null,
          fontSize: 14,
          suffixIcon: Icon(Icons.public, color: Theme.of(context).primaryColor),
        ),
        onFieldSubmitted: (_) {
          enterpriseIdFocusNode.requestFocus();
        },
        keyboardType: TextInputType.url,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return R.string.ccsUrl;
          }
          return null;
        },
      ),
    );
  }
}
