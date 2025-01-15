import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../components/components.dart';
import '../../../helpers/helpers.dart';

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
      padding: const EdgeInsets.only(top: 15),
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
          suffixIcon: Icon(Icons.radar_outlined),
          fontSize: 14,
        ),
        onFieldSubmitted: (_) {
          serviceChargePercentageFocusNode.requestFocus();
        },
        keyboardType: TextInputType.text,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return R.string.latestCompatibleVersion;
          }
          return null;
        },
      ),
    );
  }
}
