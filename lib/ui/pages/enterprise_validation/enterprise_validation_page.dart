import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'dart:async';

import '../../components/components.dart';
import '../../helpers/helpers.dart';
import '../../mixins/mixins.dart';
import './components/components.dart';
import './enterprise_validation_presenter.dart';

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
      await widget.presenter.loadLocalData();

      if (widget.presenter.enterpriseNameController.text.isNotEmpty) {
        widget.presenter.validateEnterpriseInput(
            widget.presenter.enterpriseNameController.text);
      }
    }
  }

  StreamSubscription? loadingSubscription;
  StreamSubscription? mainErrorSubscription;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
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
                  child: StreamBuilder<CommandEntity?>(
                      stream: widget.presenter.commandDataStream,
                      builder: (context, snapshotUseFixedCommand) {
                        if (snapshotUseFixedCommand.data == null) {
                          return const SizedBox();
                        }
                        return Column(
                          children: [
                            EnterpriseInput(
                              commandEntity: snapshotUseFixedCommand.data!,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Column(
                                children: [
                                  FixedNumberCommandSwitch(
                                    commandEntity:
                                        snapshotUseFixedCommand.data!,
                                  ),
                                  if (snapshotUseFixedCommand
                                          .data?.isFixedCommandNumber ==
                                      true)
                                    FixedCommandNumberInput(formKey: _formKey),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            EnterpriseValidateButton(
                              formKey: _formKey,
                              commandEntity: snapshotUseFixedCommand.data!,
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
