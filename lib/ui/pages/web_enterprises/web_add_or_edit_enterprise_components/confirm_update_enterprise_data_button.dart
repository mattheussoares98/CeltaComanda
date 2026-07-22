import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../domain/entities/entities.dart';
import '../../../../main/builders/builders.dart';
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
  final TextEditingController httpsUrlController;
  final bool? zoomImage;
  final bool? useCovenant;
  final bool? useProductReducedName;
  final bool? verifyCommandBlocked;
  final bool? canInsertCommentManually;
  final bool? blockUseAppIfIsOutdated;
  final bool? canInsertCustomer;
  final bool? canInsertQuantityManually;
  final bool? requestTableNumber;
  final bool? printSaleRequestWhenPaymentSucceeds;
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
    required this.blockUseAppIfIsOutdated,
    required this.canInsertCustomer,
    required this.canInsertQuantityManually,
    required this.requestTableNumber,
    required this.printSaleRequestWhenPaymentSucceeds,
    required this.httpsUrlController,
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
                EnterpriseEntity(
                  enterpriseConcentradorParametersEntity: EnterpriseBuilder
                      .entity?.enterpriseConcentradorParametersEntity,
                  persistApp: EnterpriseBuilder.entity?.persistApp,
                  useOldPrintWay: EnterpriseBuilder.entity?.useOldPrintWay,
                  updateDevicesInformations:
                      EnterpriseBuilder.entity?.updateDevicesInformations,
                  updateEnterprise: EnterpriseBuilder.entity?.updateEnterprise,
                  enterpriseName: enterpriseNameController.text,
                  url: navsUrlController.text,
                  concentradorUrl: concentratorUrlController.text,
                  urlCCS: ccsUrlController.text,
                  enterpriseId: enterpriseIdController.text.toInt(),
                  latestCompatibleVersion:
                      latestCompatibleVersionController.text,
                  serviceChargePercentageOrValue:
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
                  blockUseAppIfIsOutdated: blockUseAppIfIsOutdated,
                  canInsertQuantityManually: canInsertQuantityManually,
                  canInsertCustomer: canInsertCustomer,
                  requestTableNumber: requestTableNumber,
                  printSaleRequestWhenPaymentSucceeds:
                      printSaleRequestWhenPaymentSucceeds,
                  httpsUrl:
                      httpsUrlController.text.toLowerCase().removeWhiteSpaces(),
                ),
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
