import 'package:flutter/material.dart';

import '../../../components/components.dart';
import '../../../helpers/helpers.dart';

class ConfirmUpdateEnterpriseDataButton extends StatelessWidget {
  final TextEditingController enterpriseNameController;
  final TextEditingController navsUrlController;
  final TextEditingController concentratorUrlController;
  final TextEditingController ccsUrlController;
  final TextEditingController enterpriseIdController;
  final TextEditingController daysPreloadImageController;
  final TextEditingController latestCompatibleVersionController;
  final TextEditingController serviceChargePercentageController;
  final bool? zoomImage;
  final bool? useCovenant;

  const ConfirmUpdateEnterpriseDataButton({
    required this.enterpriseNameController,
    required this.navsUrlController,
    required this.concentratorUrlController,
    required this.ccsUrlController,
    required this.enterpriseIdController,
    required this.daysPreloadImageController,
    required this.latestCompatibleVersionController,
    required this.serviceChargePercentageController,
    required this.zoomImage,
    required this.useCovenant,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // EnterprisePresenter enterprisePresenter =
    //     Provider.of(context, listen: false);

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
              //enterprisePresenter.updateEnterpriseData(EnterpriseEntity)
              //TODO create function to update enterprise data
            },
          );
        },
        child: Text(R.string.updateEnterprise),
      ),
    );
  }
}
