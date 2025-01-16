import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../components/components.dart';
import '../../../helpers/helpers.dart';
import 'web_add_or_edit_enterprise_components.dart';

class DaysPreLoadImageInput extends StatelessWidget {
  final TextEditingController daysPreloadImageController;
  final FocusNode daysPreloadImageFocusNode;
  final FocusNode latestCompatibleVersionFocusNode;
  const DaysPreLoadImageInput({
    required this.daysPreloadImageController,
    required this.daysPreloadImageFocusNode,
    required this.latestCompatibleVersionFocusNode,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: TextFormField(
        controller: daysPreloadImageController,
        focusNode: daysPreloadImageFocusNode,
        inputFormatters: [
          LengthLimitingTextInputFormatter(3),
        ],
        onTap: () {
          daysPreloadImageController.selection = TextSelection(
            baseOffset: 0,
            extentOffset: daysPreloadImageController.text.length,
          );
        },
        onFieldSubmitted: (_) {
          latestCompatibleVersionFocusNode.requestFocus();
        },
        decoration: formFieldDecoration(
          context: context,
          hintText: R.string.waitDaysPreloadImage,
          labelText: R.string.waitDaysPreloadImage,
          errorText: null,
          suffixIcon: InfoIconButton(
            toltipMessage: R.string.msgDaysToPreloadImage,
          ),
          fontSize: 14,
        ),
        keyboardType: TextInputType.numberWithOptions(decimal: false),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return R.string.waitDaysPreloadImage;
          } else if (int.tryParse(value) == null) {
            return R.string.msgInvalidNumber;
          }
          return null;
        },
      ),
    );
  }
}
