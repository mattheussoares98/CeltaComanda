import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../components/components.dart';
import '../../../helpers/helpers.dart';

class EnterpriseIdInput extends StatelessWidget {
  final TextEditingController enterpriseIdController;
  final FocusNode enterpriseIdFocusNode;
  final FocusNode daysPreloadImageFocusNode;
  const EnterpriseIdInput({
    required this.enterpriseIdController,
    required this.enterpriseIdFocusNode,
    required this.daysPreloadImageFocusNode,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: TextFormField(
        controller: enterpriseIdController,
        focusNode: enterpriseIdFocusNode,
        inputFormatters: [
          LengthLimitingTextInputFormatter(3),
        ],
        onFieldSubmitted: (_) {
          daysPreloadImageFocusNode.requestFocus();
        },
        decoration: formFieldDecoration(
          context: context,
          hintText: R.string.enterpriseId,
          labelText: R.string.enterpriseId,
          errorText: null,
          suffixIcon: Icon(Icons.numbers),
          fontSize: 14,
        ),
        keyboardType: TextInputType.numberWithOptions(decimal: false),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return R.string.enterpriseId;
          } else if (int.tryParse(value) == null) {
            return R.string.msgInvalidNumber;
          }
          return null;
        },
      ),
    );
  }
}
