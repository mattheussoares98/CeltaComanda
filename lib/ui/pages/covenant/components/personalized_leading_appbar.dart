// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../data/models/models.dart';
import '../../../components/components.dart';
import '../../pages.dart';

class PersonalizedLeadingAppbar extends StatelessWidget {
  const PersonalizedLeadingAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    CovenantPresenter covenantPresenter = Provider.of(context, listen: false);

    return IconButton(
      onPressed: () async {
        AuthorizationPendingModel? authorizationPendatModel =
            await covenantPresenter.getAuthorizationPendantModel();

        if (authorizationPendatModel?.isPending == true) {
          notificationDialog(
            context: context,
            titleMessage: "Pendant helper",
            closeDialogOnConfirmPress: true,
            content: const Text(
                "Add helper with message indicating that authorization is pendant"),
            onPress: () async {
              Navigator.of(context).pop();
            },
          );
        } else {
          Navigator.of(context).pop();
        }
      },
      icon: const Icon(Icons.arrow_back),
    );
  }
}
