import 'package:clean_celta_mobile/ui/pages/enterprise_validation/enterprise_validation_presenter.dart';

import '../../../helpers/helpers.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EnterpriseInput extends StatelessWidget {
  const EnterpriseInput({super.key});

  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<EnterpriseValidationPresenter>(context);
    return StreamBuilder<UIError?>(
        stream: presenter.enterpriseErrorStream,
        builder: (context, snapshot) {
          return TextFormField(
            decoration: InputDecoration(
              labelText: R.string.validateEnterprise,
              icon: Icon(Icons.lock, color: Theme.of(context).primaryColor),
              errorText: snapshot.data?.description,
            ),
            obscureText: true,
            onChanged: presenter.validateEnterpriseInput,
          );
        });
  }
}
