import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../components/components.dart';
import '../../../helpers/helpers.dart';
import 'web_add_or_edit_enterprise_components.dart';

class LatestCompatibleVersionInput extends StatelessWidget {
  final TextEditingController latestCompatibleVersionController;
  final FocusNode latestCompatibleVersionFocusNode;
  final FocusNode serviceChargePercentageFocusNode;
  const LatestCompatibleVersionInput({
    required this.latestCompatibleVersionController,
    required this.latestCompatibleVersionFocusNode,
    required this.serviceChargePercentageFocusNode,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: TextFormField(
        focusNode: latestCompatibleVersionFocusNode,
        controller: latestCompatibleVersionController,
        inputFormatters: [
          LengthLimitingTextInputFormatter(10),
        ],
        decoration: formFieldDecoration(
          context: context,
          hintText: R.string.latestCompatibleVersion,
          labelText: R.string.latestCompatibleVersion,
          errorText: null,
          suffixIcon: InfoIconButton(
            toltipMessage: R.string.msgCompatibleVersion,
          ),
          fontSize: 14,
        ),
        onFieldSubmitted: (_) {
          serviceChargePercentageFocusNode.requestFocus();
        },
        keyboardType: TextInputType.text,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return null;
          } else if (int.tryParse(value.replaceAll(RegExp(r'\.'), '')) ==
              null) {
            return R.string.msgInvalidField;
          }
          return null;
        },
      ),
    );
  }
}
