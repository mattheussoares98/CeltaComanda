// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/components.dart';
import '../../../helpers/helpers.dart';
import '../../pages.dart';

class PersonalizedLeadingAppbar extends StatelessWidget {
  const PersonalizedLeadingAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    PaymentPresenter paymentPresenter = Provider.of(context, listen: false);

    return IconButton(
      onPressed: () async {
        if (paymentPresenter.authorizationPendingModel?.isPending == true) {
          notificationDialog(
            context: context,
            titleMessage: R.string.msgAuthorizationIsPendant,
            closeDialogOnConfirmPress: true,
            content: Text(R.string.msgPendantAuthorizationNotification),
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
