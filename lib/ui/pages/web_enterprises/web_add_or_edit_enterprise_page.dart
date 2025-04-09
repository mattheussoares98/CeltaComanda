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
  final _formKey = GlobalKey<FormState>();
  final navsFocusNode = FocusNode();
  final concentratorFocusNode = FocusNode();
  final ccsFocusNode = FocusNode();
  final enterpriseIdFocusNode = FocusNode();
  final daysPreloadImageFocusNode = FocusNode();
  final latestCompatibleVersionFocusNode = FocusNode();
  final serviceChargePercentageFocusNode = FocusNode();
  final minutesVerifyUpdateMenuFocusNode = FocusNode();
  bool? zoomImage = false;
  bool? useCovenant = false;
  bool? useProductReducedName = false;
  bool? verifyCommandBlocked = true;
  bool? canInsertCommentManually = false;
  bool? blockUseAppIfIsOutdated = false;
  bool? canInsertQuantityManually = false;

  void changeUseProductReducedName() {
    setState(() {
      useProductReducedName = !(useProductReducedName ?? false);
    });
  }

  void changeBlockUseAppIfIsOutdated() {
    setState(() {
      blockUseAppIfIsOutdated = !(blockUseAppIfIsOutdated ?? false);
    });
  }

  void changeCanInsertQuantityManually() {
    setState(() {
      canInsertQuantityManually = !(canInsertQuantityManually ?? false);
    });
  }

  void changeCanInsertCommentManually() {
    setState(() {
      canInsertCommentManually = !(canInsertCommentManually ?? false);
    });
  }

  void changeVerifyCommandIsBlocked() {
    setState(() {
      verifyCommandBlocked = !(verifyCommandBlocked ?? true);
    });
  }

  void changeZoom() {
    setState(() {
      zoomImage = !(zoomImage ?? false);
    });
  }

  void changeUseCovenant() {
    setState(() {
      useCovenant = !(useCovenant ?? false);
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
            useProductReducedName = webEnterprisesPresenter
                    .selectedEnterprise?.useReducedNameOnProduct ==
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
            icon: Icon(Icons.delete, color: Colors.red),
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
                            child: ZoomImageSwitch(
                              zoomImage: zoomImage ?? false,
                              changeZoom: changeZoom,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: UseCovenantSwitch(
                              useCovenant: useCovenant ?? false,
                              changeUseCovenant: changeUseCovenant,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: UseProductReducedNameSwitch(
                              useReducedName: useProductReducedName ?? false,
                              changeUseProductReducedName:
                                  changeUseProductReducedName,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: VerifyBlockedCommandSwitch(
                              verifyCommandIsBlocked:
                                  verifyCommandBlocked ?? false,
                              changeVerifyCommandIsBlocked:
                                  changeVerifyCommandIsBlocked,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: CanInsertCommentManuallySwitch(
                              canInsertCommentManually:
                                  canInsertCommentManually ?? false,
                              changeCanInsertCommentManually:
                                  changeCanInsertCommentManually,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: CanInsertQuantityManuallySwitch(
                              canInsertQuantityManually:
                                  canInsertQuantityManually ?? false,
                              changeCanInsertQuantityManually:
                                  changeCanInsertQuantityManually,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: BlockUseAppIfIsOutdatedSwitch(
                              blockUseAppIfIsOutdated:
                                  blockUseAppIfIsOutdated ?? false,
                              changeBlockAppIfIsOutdated:
                                  changeBlockUseAppIfIsOutdated,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: GoToDevicesInfoPageButton(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            ConfirmUpdateEnterpriseDataButton(
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
              useProductReducedName: useProductReducedName,
              formKey: _formKey,
              verifyCommandBlocked: verifyCommandBlocked,
              canInsertCommentManually: canInsertCommentManually,
              blockUseAppIfIsOutdated: blockUseAppIfIsOutdated,
              canInsertQuantityManually: canInsertQuantityManually,
            ),
          ],
        ),
      ),
    );
  }
}
