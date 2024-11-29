import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

import '../../pages.dart';
import '../../../helpers/helpers.dart';

class EnterpriseInput extends StatelessWidget {
  final TextEditingController enterpriseController;
  final TextEditingController commandNumberController;
  final bool isFixedCommandNumber;
  const EnterpriseInput({
    required this.enterpriseController,
    required this.commandNumberController,
    required this.isFixedCommandNumber,
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
            controller: enterpriseController,
            onFieldSubmitted: (_) async {
              if (enterpriseController.text.isNotEmpty) {
                await presenter.validateApiAndGoToHomePage(
                  commandNumber: commandNumberController.text,
                  isFixedCommandNumber: isFixedCommandNumber,
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
