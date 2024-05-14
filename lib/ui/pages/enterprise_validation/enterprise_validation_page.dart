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

  @override
  void dispose() {
    super.dispose();
    loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          loadingSubscription =
              handleLoading(context, widget.presenter.isLoadingStream);
          mainErrorSubscription =
              handleMainError(context, widget.presenter.mainErrorStream);

          return GestureDetector(
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
                      child: const Form(
                        child: Column(
                          children: [
                            EnterpriseInput(),
                            SizedBox(height: 10),
                            EnterpriseValidateButton(),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
