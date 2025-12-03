import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/components.dart';
import '../../helpers/helpers.dart';
import '../pages.dart';
import 'web_add_or_edit_enterprise_components/web_add_or_edit_enterprise_components.dart';

class WebAddOrEditEnterprisePage extends StatefulWidget {
  const WebAddOrEditEnterprisePage({super.key});

  @override
  State<WebAddOrEditEnterprisePage> createState() =>
      _WebAddOrEditEnterprisePageState();
}

class _WebAddOrEditEnterprisePageState
    extends State<WebAddOrEditEnterprisePage> {
  final enterpriseNameController = TextEditingController();
  final navsUrlController = TextEditingController();
  final concentratorUrlController = TextEditingController();
  final ccsUrlController = TextEditingController();
  final enterpriseIdController = TextEditingController();
  final daysPreloadImageController = TextEditingController();
  final latestCompatibleVersionController = TextEditingController();
  final serviceChargePercentageController = TextEditingController();
  final minutesVerifyUpdateMenuController = TextEditingController();
  final httpsUrlController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final navsFocusNode = FocusNode();
  final concentratorFocusNode = FocusNode();
  final ccsFocusNode = FocusNode();
  final enterpriseIdFocusNode = FocusNode();
  final daysPreloadImageFocusNode = FocusNode();
  final latestCompatibleVersionFocusNode = FocusNode();
  final serviceChargePercentageFocusNode = FocusNode();
  final minutesVerifyUpdateMenuFocusNode = FocusNode();
  bool zoomImage = false;
  bool useCovenant = false;
  bool useReducedNameOnProduct = false;
  bool verifyCommandBlocked = true;
  bool canInsertCommentManually = false;
  bool blockUseAppIfIsOutdated = false;
  bool canInsertQuantityManually = false;
  bool canInsertCustomer = false;
  bool requestTableNumber = false;

  void changeUseProductReducedName() {
    setState(() {
      useReducedNameOnProduct = !(useReducedNameOnProduct);
    });
  }

  void changeRequestTableNumber() {
    setState(() {
      requestTableNumber = !(requestTableNumber);
    });
  }

  void changeBlockUseAppIfIsOutdated() {
    setState(() {
      blockUseAppIfIsOutdated = !(blockUseAppIfIsOutdated);
    });
  }

  void changeCanInsertQuantityManually() {
    setState(() {
      canInsertQuantityManually = !(canInsertQuantityManually);
    });
  }

  void changeCanInsertCustomer() {
    setState(() {
      canInsertCustomer = !(canInsertCustomer);
    });
  }

  void changeCanInsertCommentManually() {
    setState(() {
      canInsertCommentManually = !(canInsertCommentManually);
    });
  }

  void changeVerifyCommandIsBlocked() {
    setState(() {
      verifyCommandBlocked = !(verifyCommandBlocked);
    });
  }

  void changeZoom() {
    setState(() {
      zoomImage = !(zoomImage);
    });
  }

  void changeUseCovenant() {
    setState(() {
      useCovenant = !(useCovenant);
    });
  }

  @override
  void dispose() {
    super.dispose();

    enterpriseNameController.dispose();
    navsUrlController.dispose();
    concentratorUrlController.dispose();
    ccsUrlController.dispose();
    enterpriseIdController.dispose();
    daysPreloadImageController.dispose();
    latestCompatibleVersionController.dispose();
    serviceChargePercentageController.dispose();
    minutesVerifyUpdateMenuController.dispose();
    httpsUrlController.dispose();
    navsFocusNode.dispose();
    concentratorFocusNode.dispose();
    ccsFocusNode.dispose();
    enterpriseIdFocusNode.dispose();
    daysPreloadImageFocusNode.dispose();
    latestCompatibleVersionFocusNode.dispose();
    serviceChargePercentageFocusNode.dispose();
    minutesVerifyUpdateMenuFocusNode.dispose();
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        WebEnterprisesPresenter webEnterprisesPresenter =
            Provider.of(context, listen: false);

        // daysPreloadImageController.text = (webEnterprisesPresenter
        //             .selectedEnterprise?.waitDaysToPreloadImages ??
        //         1)
        //     .toString();
        if (webEnterprisesPresenter.selectedEnterprise != null) {
          setState(() {
            enterpriseNameController.text =
                webEnterprisesPresenter.selectedEnterprise?.enterpriseName ??
                    "ERROR";
            navsUrlController.text =
                webEnterprisesPresenter.selectedEnterprise?.url ?? "";
            concentratorUrlController.text =
                webEnterprisesPresenter.selectedEnterprise?.concentradorUrl ??
                    "";
            ccsUrlController.text =
                webEnterprisesPresenter.selectedEnterprise?.urlCCS ?? "";
            enterpriseIdController.text =
                (webEnterprisesPresenter.selectedEnterprise?.enterpriseId ?? 0)
                    .toString();
            latestCompatibleVersionController.text = webEnterprisesPresenter
                    .selectedEnterprise?.latestCompatibleVersion ??
                "".toString();
            serviceChargePercentageController.text = webEnterprisesPresenter
                        .selectedEnterprise?.serviceChargePercentageOrValue ==
                    null
                ? ""
                : webEnterprisesPresenter
                    .selectedEnterprise!.serviceChargePercentageOrValue!
                    .toInt()
                    .toString();
            zoomImage =
                webEnterprisesPresenter.selectedEnterprise?.zoomImage == true;
            useCovenant =
                webEnterprisesPresenter.selectedEnterprise?.useCovenant == true;
            useReducedNameOnProduct = webEnterprisesPresenter
                    .selectedEnterprise?.useReducedNameOnProduct ==
                true;
            requestTableNumber = webEnterprisesPresenter
                    .selectedEnterprise?.requestTableNumber ==
                true;

            if (webEnterprisesPresenter
                    .selectedEnterprise?.verifyCommandBlocked !=
                null) {
              verifyCommandBlocked = webEnterprisesPresenter
                      .selectedEnterprise?.verifyCommandBlocked ==
                  true;
            }
            canInsertCommentManually = webEnterprisesPresenter
                    .selectedEnterprise?.canInsertCommentManually ==
                true;
            blockUseAppIfIsOutdated = webEnterprisesPresenter
                    .selectedEnterprise?.blockUseAppIfIsOutdated ==
                true;
            canInsertQuantityManually = webEnterprisesPresenter
                    .selectedEnterprise?.canInsertQuantityManually ==
                true;
            canInsertCustomer =
                webEnterprisesPresenter.selectedEnterprise?.canInsertCustomer ==
                    true;
            minutesVerifyUpdateMenuController.text = webEnterprisesPresenter
                        .selectedEnterprise?.minutesVerifyUpdateMenu !=
                    null
                ? webEnterprisesPresenter
                    .selectedEnterprise!.minutesVerifyUpdateMenu!
                    .toString()
                : "5";
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    WebEnterprisesPresenter webEnterprisesPresenter =
        Provider.of(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          webEnterprisesPresenter.selectedEnterprise?.enterpriseName ?? '',
        ),
        actions: [
          IconButton(
            onPressed: () async {
              notificationDialog(
                context: context,
                titleMessage: R.string.deleteEnterprise,
                content: Text(
                  R.string.msgWantDeleteEnterprise,
                  textAlign: TextAlign.center,
                ),
                onPress: () async {
                  final deleted =
                      await webEnterprisesPresenter.deleteEnterpriseData();
                  if (deleted) {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                    await webEnterprisesPresenter.loadEnterprises();
                  }
                },
              );
            },
            icon: const Icon(Icons.delete, color: Colors.red),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      EnterpriseNameInput(
                        enterpriseNameController: enterpriseNameController,
                        navsFocusNode: navsFocusNode,
                      ),
                      NavsUrlInput(
                        navsUrlController: navsUrlController,
                        navsFocusNode: navsFocusNode,
                        concentratorFocusNode: concentratorFocusNode,
                      ),
                      ConcentratorUrlInput(
                        concentratorController: concentratorUrlController,
                        concentratorFocusNode: concentratorFocusNode,
                        ccsFocusNode: ccsFocusNode,
                      ),
                      CcsUrlInput(
                        ccsController: ccsUrlController,
                        ccsFocusNode: ccsFocusNode,
                        enterpriseIdFocusNode: enterpriseIdFocusNode,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: EnterpriseIdInput(
                              enterpriseIdController: enterpriseIdController,
                              enterpriseIdFocusNode: enterpriseIdFocusNode,
                              daysPreloadImageFocusNode:
                                  daysPreloadImageFocusNode,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: MinutesVerifyUpdateMenuInput(
                              minutesVerifyUpdateMenuController:
                                  minutesVerifyUpdateMenuController,
                              minutesVerifyUpdateMenuFocusNode:
                                  minutesVerifyUpdateMenuFocusNode,
                              latestCompatibleVersionFocusNode:
                                  latestCompatibleVersionFocusNode,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: LatestCompatibleVersionInput(
                              latestCompatibleVersionController:
                                  latestCompatibleVersionController,
                              latestCompatibleVersionFocusNode:
                                  latestCompatibleVersionFocusNode,
                              serviceChargePercentageFocusNode:
                                  serviceChargePercentageFocusNode,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ServiceChargePercentageInput(
                              serviceChargePercentageController:
                                  serviceChargePercentageController,
                              serviceChargePercentageFocusNode:
                                  serviceChargePercentageFocusNode,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: PersonalizedSwitch(
                              value: zoomImage,
                              changeValue: changeZoom,
                              title: R.string.zoomImage,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: PersonalizedSwitch(
                              value: useCovenant,
                              changeValue: changeUseCovenant,
                              title: R.string.enableCovenant,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: PersonalizedSwitch(
                              value: useReducedNameOnProduct,
                              changeValue: changeUseProductReducedName,
                              title: R.string.useProductReducedName,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: PersonalizedSwitch(
                              value: verifyCommandBlocked,
                              changeValue: changeVerifyCommandIsBlocked,
                              title: R.string.needLiberateCommand,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: PersonalizedSwitch(
                              value: canInsertCommentManually,
                              changeValue: changeCanInsertCommentManually,
                              title: R.string.canInsertCommentManually,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: PersonalizedSwitch(
                              value: canInsertQuantityManually,
                              changeValue: changeCanInsertQuantityManually,
                              title: R.string.canInsertQuantityManually,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: PersonalizedSwitch(
                              value: blockUseAppIfIsOutdated,
                              changeValue: changeBlockUseAppIfIsOutdated,
                              title: R.string.blockUseAppIfIsOutdated,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: PersonalizedSwitch(
                              value: canInsertCustomer,
                              changeValue: changeCanInsertCustomer,
                              title: R.string.canInsertCustomer,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: PersonalizedSwitch(
                              value: requestTableNumber,
                              changeValue: changeRequestTableNumber,
                              title: R.string.requestTableNumber,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Expanded(
                            child: GoToDevicesInfoPageButton(),
                          ),
                        ],
                      ),
                      //TODO add httpsUrl param
                    ],
                  ),
                ),
              ),
            ),
            ConfirmUpdateEnterpriseDataButton(
              httpsUrlController: httpsUrlController,
              enterpriseNameController: enterpriseNameController,
              navsUrlController: navsUrlController,
              concentratorUrlController: concentratorUrlController,
              ccsUrlController: ccsUrlController,
              enterpriseIdController: enterpriseIdController,
              daysPreloadImageController: daysPreloadImageController,
              latestCompatibleVersionController:
                  latestCompatibleVersionController,
              serviceChargePercentageController:
                  serviceChargePercentageController,
              minutesVerifyUpdateMenuController:
                  minutesVerifyUpdateMenuController,
              zoomImage: zoomImage,
              useCovenant: useCovenant,
              useProductReducedName: useReducedNameOnProduct,
              formKey: _formKey,
              verifyCommandBlocked: verifyCommandBlocked,
              canInsertCommentManually: canInsertCommentManually,
              blockUseAppIfIsOutdated: blockUseAppIfIsOutdated,
              canInsertQuantityManually: canInsertQuantityManually,
              canInsertCustomer: canInsertCustomer,
              requestTableNumber: requestTableNumber,
            ),
          ],
        ),
      ),
    );
  }
}
