import 'dart:async';

import '../../components/components.dart';
import '../../helpers/helpers.dart';
import '../../mixins/mixins.dart';
import 'components/components.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'enterprise_validation_presenter.dart';

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
  final GlobalKey _tooltipKey = GlobalKey();
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
                  child: StreamBuilder<bool>(
                      stream: widget.presenter.useFixedCommandNumber,
                      builder: (context, snapshotUseFixedCommand) {
                        return Column(
                          children: [
                            const EnterpriseInput(),
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Switch(
                                        value: snapshotUseFixedCommand.data ??
                                            false,
                                        onChanged: (_) {
                                          widget.presenter
                                              .updateUseFixedCommandNumber();
                                        },
                                      ),
                                      const SizedBox(width: 10),
                                      Flexible(
                                        child: Text(
                                          "Usar sempre a mesma mesa",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: hasMinWidth(context)
                                                  ? 23
                                                  : 15),
                                        ),
                                      ),
                                      const SizedBox(width: 20),
                                      GestureDetector(
                                        onTap: () {
                                          final dynamic tooltip =
                                              _tooltipKey.currentState;
                                          tooltip.ensureTooltipVisible();
                                        },
                                        child: Tooltip(
                                          key: _tooltipKey,
                                          message:
                                              'Essa opção deve ser usada somente quando estiver utilizando um tablet fixo por mesa',
                                          child: Icon(
                                            Icons.info,
                                            size:
                                                hasMinWidth(context) ? 40 : 30,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  if (snapshotUseFixedCommand.data == true)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 15.0),
                                      child: Form(
                                        key: _formKey,
                                        child: TextFormField(
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          autofocus: true,
                                          keyboardType: TextInputType.number,
                                          maxLength: 3,
                                          validator: (value) {
                                            if (value == null) {
                                              return "Digite o número da mesa";
                                            } else if (int.tryParse(value) ==
                                                null) {
                                              return "Número inválido";
                                            } else {
                                              return null;
                                            }
                                          },
                                          decoration: const InputDecoration(
                                            label: Text("Número da mesa"),
                                            hintText: "Número da mesa",
                                            counterText: "",
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            EnterpriseValidateButton(
                              formKey: _formKey,
                              useFixedCommandNumber:
                                  snapshotUseFixedCommand.data ?? false,
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
