// ignore_for_file: use_build_context_synchronously

import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'dart:async';

import '../../../main/builders/builders.dart';
import '../../components/components.dart';
import '../../helpers/helpers.dart';
import '../../mixins/mixins.dart';
import '../pages.dart';

class EnterpriseValidationPage extends StatefulWidget {
  const EnterpriseValidationPage({super.key});

  @override
  State<EnterpriseValidationPage> createState() =>
      _EnterpriseValidationPageState();
}

class _EnterpriseValidationPageState extends State<EnterpriseValidationPage>
    with KeyboardManager, LoadingManager, UIErrorManager {
  final enterpriseController = TextEditingController();
  StreamSubscription? loadingSubscription;
  StreamSubscription? mainErrorSubscription;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isFixedCommandNumber = false;
  final commandNumberController = TextEditingController();
  PdvNotUsingViewModel? selectedPdv;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        Future.delayed(Duration.zero, () async {
          EnterprisePresenter enterprisePresenter =
              Provider.of(context, listen: false);
          await enterprisePresenter.updateEnterpriseWithLocalData();
          if (EnterpriseBuilder.entity != null &&
              EnterpriseBuilder.entity?.enterpriseName != "") {
            enterpriseController.text =
                EnterpriseBuilder.entity!.enterpriseName;
          }

          if (enterpriseController.text.isNotEmpty) {
            enterprisePresenter
                .validateEnterpriseInput(enterpriseController.text);
          }
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();
    commandNumberController.dispose();
  }

  Future<void> _validateEnterprise({
    required EnterprisePresenter enterprisePresenter,
    required HomePresenter homePresenter,
  }) async {
    if ((_formKey.currentState == null || !_formKey.currentState!.validate()) &&
        isFixedCommandNumber) {
      return;
    }

    await enterprisePresenter.validateEnterpriseByName(
      commandNumber: commandNumberController.text,
      isFixedCommandNumber: isFixedCommandNumber,
      homePresenter: homePresenter,
    );
  }

  @override
  Widget build(BuildContext context) {
    HomePresenter homePresenter = Provider.of(context, listen: false);
    EnterprisePresenter enterprisePresenter =
        Provider.of(context, listen: false);

    loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();

    loadingSubscription =
        handleLoading(context, enterprisePresenter.isLoadingStream);
    mainErrorSubscription =
        handleMainError(context, enterprisePresenter.mainErrorStream);

    return Scaffold(
      body: GestureDetector(
        onTap: () => hideKeyboard(context),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const LoginHeader(),
              Headline1(text: R.string.validateEnterprise),
              Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  children: [
                    EnterpriseInput(
                      enterpriseController: enterpriseController,
                      commandNumberController: commandNumberController,
                      isFixedCommandNumber: isFixedCommandNumber,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Column(
                        children: [
                          FixedNumberCommandSwitch(
                            isFixedCommandNumber: isFixedCommandNumber,
                            updateIsFixedCommandNumber: () {
                              setState(() {
                                isFixedCommandNumber = !isFixedCommandNumber;
                              });
                            },
                          ),
                          if (isFixedCommandNumber)
                            FixedCommandNumberInput(
                              isFixedCommandNumber: isFixedCommandNumber,
                              commandNumberController: commandNumberController,
                              formKey: _formKey,
                              validateEnterprise: () async {
                                await _validateEnterprise(
                                  homePresenter: homePresenter,
                                  enterprisePresenter: enterprisePresenter,
                                );
                              },
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    EnterpriseValidateButton(
                      validateEnterprise: () async {
                        await _validateEnterprise(
                          homePresenter: homePresenter,
                          enterprisePresenter: enterprisePresenter,
                        );
                        setState(() {
                          selectedPdv = null;
                        });
                      },
                    ),
                    if (homePresenter.isGeneratingVersionToGetNet ||
                        homePresenter.isGeneratingVersionToRede)
                      PdvNotUsingDropdown(
                        isFixedCommandNumber: isFixedCommandNumber,
                        commandNumberController: commandNumberController,
                        selectedPdv: selectedPdv,
                        updateSelectedPdv: (value) {
                          setState(() {
                            selectedPdv = value;
                          });
                        },
                      ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
