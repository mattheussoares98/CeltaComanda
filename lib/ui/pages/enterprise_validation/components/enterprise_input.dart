import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

import '../../../../ui/pages/pages.dart';
import '../../../helpers/helpers.dart';

class EnterpriseInput extends StatelessWidget {
  final CommandEntity commandEntity;
  const EnterpriseInput({
    required this.commandEntity,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<EnterpriseValidationPresenter>(context);
    return StreamBuilder<UIError?>(
        stream: presenter.enterpriseErrorStream,
        builder: (context, snapshot) {
          return TextFormField(
            decoration: InputDecoration(
              labelText: R.string.enterprise,
              icon: Icon(Icons.business, color: Theme.of(context).primaryColor),
              errorText: snapshot.data?.description,
            ),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: presenter.enterpriseNameController,
            onFieldSubmitted: (_) async {
              if (presenter.enterpriseNameController.text.isNotEmpty) {
                await presenter.getEnterpriseAndValidateApiIsAvailable(
                  commandEntity: commandEntity,
                );
              }
            },
            onChanged: (value) => presenter.validateEnterpriseInput(value,
                updateEnterpriseNameController: true),
          );
        });
  }
}
