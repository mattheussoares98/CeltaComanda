import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  final concentratorController = TextEditingController();
  final ccsController = TextEditingController();
  final enterpriseIdController = TextEditingController();
  final daysPreloadImageController = TextEditingController();
  final latestCompatibleVersionController = TextEditingController();
  final serviceChargePercentageController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final navsFocusNode = FocusNode();
  final concentratorFocusNode = FocusNode();
  final ccsFocusNode = FocusNode();
  final enterpriseIdFocusNode = FocusNode();
  final daysPreloadImageFocusNode = FocusNode();
  final latestCompatibleVersionFocusNode = FocusNode();
  final serviceChargePercentageFocusNode = FocusNode();
  bool zoomImage = false;
  bool useCovenant = false;

  void changeZoom() {
    setState(() {
      zoomImage = !zoomImage;
    });
  }

  void changeUseCovenant() {
    setState(() {
      useCovenant = !useCovenant;
    });
  }

  @override
  void dispose() {
    super.dispose();

    enterpriseNameController.dispose();
    navsUrlController.dispose();
    concentratorController.dispose();
    ccsController.dispose();
    enterpriseIdController.dispose();
    daysPreloadImageController.dispose();
    latestCompatibleVersionController.dispose();
    serviceChargePercentageController.dispose();
    navsFocusNode.dispose();
    concentratorFocusNode.dispose();
    ccsFocusNode.dispose();
    enterpriseIdFocusNode.dispose();
    daysPreloadImageFocusNode.dispose();
    latestCompatibleVersionFocusNode.dispose();
    serviceChargePercentageFocusNode.dispose();
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        WebEnterprisesPresenter webEnterprisesPresenter =
            Provider.of(context, listen: false);

        if (webEnterprisesPresenter.selectedEnterprise != null) {
          enterpriseNameController.text =
              webEnterprisesPresenter.selectedEnterprise!.enterpriseName;
          navsUrlController.text =
              webEnterprisesPresenter.selectedEnterprise!.url ?? "";
          concentratorController.text =
              webEnterprisesPresenter.selectedEnterprise!.concentradorUrl ?? "";
          ccsController.text =
              webEnterprisesPresenter.selectedEnterprise!.urlCCS ?? "";
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
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
                concentratorController: concentratorController,
                concentratorFocusNode: concentratorFocusNode,
                ccsFocusNode: ccsFocusNode,
              ),
              CcsUrlInput(
                ccsController: ccsController,
                ccsFocusNode: ccsFocusNode,
                enterpriseIdFocusNode: enterpriseIdFocusNode,
              ),
              Row(
                children: [
                  Expanded(
                    child: EnterpriseIdInput(
                      enterpriseIdController: enterpriseIdController,
                      enterpriseIdFocusNode: enterpriseIdFocusNode,
                      daysPreloadImageFocusNode: daysPreloadImageFocusNode,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: DaysPreLoadImageInput(
                      daysPreloadImageController: daysPreloadImageController,
                      daysPreloadImageFocusNode: daysPreloadImageFocusNode,
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
                      zoomImage: zoomImage,
                      changeZoom: changeZoom,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: UseCovenantSwitch(
                      useCovenant: useCovenant,
                      changeUseCovenant: changeUseCovenant,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(child: UpdateMenuInDevicesButton()),
                  const SizedBox(width: 8),
                  Expanded(child: UpdateDeviceInformationsButton()),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
