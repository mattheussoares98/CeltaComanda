import '../../../helpers/helpers.dart';
import '../enterprise.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EnterpriseValidateButton extends StatelessWidget {
  final void Function() validateEnterprise;
  const EnterpriseValidateButton({
    required this.validateEnterprise,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<EnterprisePresenter>(context);
    return StreamBuilder<bool>(
        stream: presenter.isFormValidStream,
        builder: (context, snapshot) {
          return ElevatedButton(
            onPressed: snapshot.data == false ? null : validateEnterprise,
            child: Text(R.string.validateEnterprise.toUpperCase()),
          );
        });
  }
}
