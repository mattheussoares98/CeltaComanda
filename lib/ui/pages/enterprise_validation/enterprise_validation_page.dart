import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'dart:async';

import '../../components/components.dart';
import '../../helpers/helpers.dart';
import '../../mixins/mixins.dart';
import '../pages.dart';

class EnterpriseValidationPage extends StatefulWidget {
  final EnterpriseValidationPresenter presenter;

  const EnterpriseValidationPage(this.presenter, {super.key});

  @override
  State<EnterpriseValidationPage> createState() =>
      _EnterpriseValidationPageState();
}

class _EnterpriseValidationPageState extends State<EnterpriseValidationPage>
    with KeyboardManager, LoadingManager, UIErrorManager {
  bool _isLoaded = false;
  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (!_isLoaded) {
      _isLoaded = true;
      HomePresenter homePresenter = Provider.of(context, listen: false);
      await widget.presenter.loadLocalData(homePresenter);

      if (widget.presenter.enterpriseNameController.text.isNotEmpty) {
        widget.presenter.validateEnterpriseInput(
            widget.presenter.enterpriseNameController.text);
      }
    }
  }

  Future<void> _validateEnterprise({
    required CommandViewModel commandViewModel,
    required EnterpriseValidationPresenter enterpriseValidationPresenter,
    required HomePresenter homePresenter,
  }) async {
    if (commandViewModel.isFixedCommandNumber == "true") {
      if (_formKey.currentState == null || !_formKey.currentState!.validate()) {
        return;
      }

      await enterpriseValidationPresenter
          .getEnterpriseAndValidateApiIsAvailable(
        commandEntity: commandViewModel.toEntity(),
        homePresenter: homePresenter,
      );
    } else {
      await enterpriseValidationPresenter
          .getEnterpriseAndValidateApiIsAvailable(
        commandEntity: commandViewModel.toEntity(),
        homePresenter: homePresenter,
      );
    }
  }

  StreamSubscription? loadingSubscription;
  StreamSubscription? mainErrorSubscription;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final commandNumberController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();
    commandNumberController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    HomePresenter homePresenter = Provider.of(context, listen: false);

    loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();

    loadingSubscription =
        handleLoading(context, widget.presenter.isLoadingStream);
    mainErrorSubscription =
        handleMainError(context, widget.presenter.mainErrorStream);

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
                child: ListenableProvider(
                  create: (_) => widget.presenter,
                  child: StreamBuilder<CommandViewModel?>(
                      stream: widget.presenter.commandDataStream,
                      builder: (context, snapshotCommandData) {
                        if (snapshotCommandData.data == null) {
                          return const SizedBox();
                        }
                        return Column(
                          children: [
                            EnterpriseInput(
                              commandVideModel: snapshotCommandData.data!,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Column(
                                children: [
                                  FixedNumberCommandSwitch(
                                    commandViewModel: snapshotCommandData.data!,
                                  ),
                                  if (snapshotCommandData
                                          .data?.isFixedCommandNumber ==
                                      "true")
                                    FixedCommandNumberInput(
                                      formKey: _formKey,
                                      commandViewModel:
                                          snapshotCommandData.data!,
                                      validateEnterprise: () async {
                                        await _validateEnterprise(
                                          homePresenter: homePresenter,
                                          commandViewModel:
                                              snapshotCommandData.data!,
                                          enterpriseValidationPresenter:
                                              widget.presenter,
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
                                  commandViewModel: snapshotCommandData.data!,
                                  enterpriseValidationPresenter:
                                      widget.presenter,
                                );
                              },
                            ),
                          ],
                        );
                      }),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
