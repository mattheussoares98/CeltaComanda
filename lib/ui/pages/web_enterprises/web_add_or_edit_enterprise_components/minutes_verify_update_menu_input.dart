import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../components/components.dart';
import '../../../helpers/helpers.dart';
import 'web_add_or_edit_enterprise_components.dart';

class MinutesVerifyUpdateMenuInput extends StatelessWidget {
  final TextEditingController minutesVerifyUpdateMenuController;
  final FocusNode minutesVerifyUpdateMenuFocusNode;
  final FocusNode latestCompatibleVersionFocusNode;
  const MinutesVerifyUpdateMenuInput({
    required this.minutesVerifyUpdateMenuController,
    required this.minutesVerifyUpdateMenuFocusNode,
    required this.latestCompatibleVersionFocusNode,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: TextFormField(
        controller: minutesVerifyUpdateMenuController,
        focusNode: minutesVerifyUpdateMenuFocusNode,
        inputFormatters: [
          LengthLimitingTextInputFormatter(3),
        ],
        onTap: () {
          minutesVerifyUpdateMenuController.selection = TextSelection(
            baseOffset: 0,
            extentOffset: minutesVerifyUpdateMenuController.text.length,
          );
        },
        onFieldSubmitted: (_) {
          latestCompatibleVersionFocusNode.requestFocus();
        },
        decoration: formFieldDecoration(
          context: context,
          hintText: R.string.minutesVerifyUpdateMenu,
          labelText: R.string.minutesVerifyUpdateMenu,
          errorText: null,
          suffixIcon: InfoIconButton(
            toltipMessage: R.string.msgMinutesVerifyUpdateMenu,
          ),
          fontSize: 14,
        ),
        keyboardType: TextInputType.numberWithOptions(decimal: false),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return null;
          } else if (int.tryParse(value) == null) {
            return R.string.msgInvalidNumber;
          } else if (value.toInt() == 0) {
            return R.string.msgInvalidNumber;
          }
          return null;
        },
      ),
    );
  }
}
