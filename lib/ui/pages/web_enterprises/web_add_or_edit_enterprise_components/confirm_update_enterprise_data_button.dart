import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/components.dart';
import '../../../helpers/helpers.dart';
import '../../pages.dart';

class ConfirmUpdateEnterpriseDataButton extends StatelessWidget {
  final TextEditingController enterpriseNameController;
  final TextEditingController navsUrlController;
  final TextEditingController concentratorUrlController;
  final TextEditingController ccsUrlController;
  final TextEditingController enterpriseIdController;
  final TextEditingController daysPreloadImageController;
  final TextEditingController latestCompatibleVersionController;
  final TextEditingController serviceChargePercentageController;
  final TextEditingController minutesVerifyUpdateMenuController;
  final bool? zoomImage;
  final bool? useCovenant;
  final bool? useProductReducedName;
  final bool? verifyCommandBlocked;
  final bool? canInsertCommentManually;
  final GlobalKey<FormState> formKey;

  const ConfirmUpdateEnterpriseDataButton({
    required this.enterpriseNameController,
    required this.navsUrlController,
    required this.concentratorUrlController,
    required this.ccsUrlController,
    required this.enterpriseIdController,
    required this.daysPreloadImageController,
    required this.latestCompatibleVersionController,
    required this.serviceChargePercentageController,
    required this.minutesVerifyUpdateMenuController,
    required this.zoomImage,
    required this.formKey,
    required this.useCovenant,
    required this.useProductReducedName,
    required this.verifyCommandBlocked,
    required this.canInsertCommentManually,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    WebEnterprisesPresenter webEnterprisesPresenter =
        Provider.of(context, listen: false);

    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: ElevatedButton(
        style: TextButton.styleFrom(
          backgroundColor: Theme.of(context).secondaryHeaderColor,
        ),
        onPressed: () {
          notificationDialog(
            context: context,
            titleMessage: R.string.updateEnterprise,
            content: Text(
              R.string.msgWantUpdateEnterpriseData,
              textAlign: TextAlign.center,
            ),
            onPress: () async {
              bool? isValid = formKey.currentState?.validate();

              if (isValid != true) {
                return;
              }

              bool updated = await webEnterprisesPresenter.updateEnterprise(
                enterpriseName: enterpriseNameController.text,
                navsUrl: navsUrlController.text,
                concentratorUrl: concentratorUrlController.text,
                ccsUrl: ccsUrlController.text,
                enterpriseId: enterpriseIdController.text.toInt(),
                // daysPreloadImage: daysPreloadImageController.text.isEmpty
                //     ? null
                //     : daysPreloadImageController.text.toInt(),
                latestCompatibleVersion: latestCompatibleVersionController.text,
                serviceChargePercentage:
                    serviceChargePercentageController.text.isEmpty
                        ? null
                        : serviceChargePercentageController.text.toDouble(),
                zoomImage: zoomImage,
                useCovenant: useCovenant,
                minutesVerifyUpdateMenu:
                    minutesVerifyUpdateMenuController.text.isEmpty
                        ? null
                        : minutesVerifyUpdateMenuController.text.toInt(),
                useReducedNameOnProduct: useProductReducedName,
                verifyCommandBlocked: verifyCommandBlocked,
                canInsertCommentManually: canInsertCommentManually,
              );

              if (updated) {
                Navigator.of(context).popUntil((route) => route.isFirst);
                await webEnterprisesPresenter.loadEnterprises();
              }
            },
          );
        },
        child: Text(R.string.updateEnterprise),
      ),
    );
  }
}
