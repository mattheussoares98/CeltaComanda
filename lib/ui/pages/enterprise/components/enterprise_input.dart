import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

import '../../pages.dart';
import '../../../helpers/helpers.dart';

class EnterpriseInput extends StatelessWidget {
  final CommandViewModel commandVideModel;
  const EnterpriseInput({
    required this.commandVideModel,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    EnterprisePresenter presenter = Provider.of(context, listen: false);
    HomePresenter homePresenter = Provider.of(context, listen: false);

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
                await presenter.validateApiAndGoToHomePage(
                  commandEntity: commandVideModel.toEntity(),
                  homePresenter: homePresenter,
                );
              }
            },
            onChanged: (value) => presenter.validateEnterpriseInput(value,
                updateEnterpriseNameController: true),
          );
        });
  }
}
