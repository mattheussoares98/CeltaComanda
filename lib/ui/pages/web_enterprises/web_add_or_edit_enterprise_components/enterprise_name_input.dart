import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../main/builders/builders.dart';
import '../../../components/components.dart';
import '../../../helpers/helpers.dart';
import 'web_add_or_edit_enterprise_components.dart';

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
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: enterpriseNameController,
            keyboardType: TextInputType.text,
            inputFormatters: [
              LengthLimitingTextInputFormatter(50),
            ],
            onFieldSubmitted: (_) {
              navsFocusNode.requestFocus();
            },
            decoration: formFieldDecoration(
              context: context,
              hintText: R.string.enterprise,
              labelText: R.string.enterprise,
              errorText: null,
              fontSize: 14,
              suffixIcon:
                  Icon(Icons.business, color: Theme.of(context).primaryColor),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return R.string.msgWriteName;
              }
              return null;
            },
          ),
        ),
        if (EnterpriseBuilder.entity != null)
          InfoIconButton(
            toltipMessage:
                "${R.string.id}: ${EnterpriseBuilder.entity?.firebaseEnterpriseId ?? ""}",
          ),
      ],
    );
  }
}
