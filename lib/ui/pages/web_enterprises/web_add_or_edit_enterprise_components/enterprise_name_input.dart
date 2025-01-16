import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../components/components.dart';
import '../../../helpers/helpers.dart';
import '../../pages.dart';
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
    WebEnterprisesPresenter webEnterprisesPresenter =
        Provider.of(context, listen: false);

    return Row(
      children: [
        Expanded(
          child: TextFormField(
            enabled: webEnterprisesPresenter.selectedEnterprise == null,
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
              fontSize: 14,
              suffixIcon: Icon(Icons.business, color: Theme.of(context).primaryColor),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return R.string.msgWriteName;
              }
              return null;
            },
          ),
        ),
        if (webEnterprisesPresenter.selectedEnterprise != null)
          InfoIconButton(
            toltipMessage: R.string.msgCantChangeEnterpriseName,
          ),
      ],
    );
  }
}
