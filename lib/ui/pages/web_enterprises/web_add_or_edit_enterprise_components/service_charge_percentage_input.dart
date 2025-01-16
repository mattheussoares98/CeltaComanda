import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../components/components.dart';
import '../../../helpers/helpers.dart';
import 'web_add_or_edit_enterprise_components.dart';

class ServiceChargePercentageInput extends StatelessWidget {
  final TextEditingController serviceChargePercentageController;
  final FocusNode serviceChargePercentageFocusNode;
  // final FocusNode daysPreloadImageFocusNode;
  const ServiceChargePercentageInput({
    required this.serviceChargePercentageController,
    required this.serviceChargePercentageFocusNode,
    // required this.daysPreloadImageFocusNode,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: TextFormField(
        controller: serviceChargePercentageController,
        focusNode: serviceChargePercentageFocusNode,
        onTap: () {
          serviceChargePercentageController.selection = TextSelection(
            baseOffset: 0,
            extentOffset: serviceChargePercentageController.text.length,
          );
        },
        inputFormatters: [
          LengthLimitingTextInputFormatter(2),
        ],
        onFieldSubmitted: (_) {
          // daysPreloadImageFocusNode.requestFocus();
        },
        decoration: formFieldDecoration(
          context: context,
          hintText: R.string.serviceChargePercentage,
          labelText: R.string.serviceChargePercentage,
          errorText: null,
          suffixIcon: InfoIconButton(
            toltipMessage: R.string.msgServiceChargeValueInfo,
          ),
          fontSize: 14,
        ),
        keyboardType: TextInputType.numberWithOptions(decimal: false),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return R.string.serviceChargePercentage;
          } else if (int.tryParse(value) == null) {
            return R.string.msgInvalidNumber;
          } else if (value.toInt() > 99) {
            return R.string.msgInvalidNumber;
          }
          return null;
        },
      ),
    );
  }
}
