import '../../components/components.dart';
import '../../helpers/helpers.dart';
import '../../mixins/mixins.dart';
import './components/components.dart';
import './login.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget
    with KeyboardManager, LoadingManager, UIErrorManager, NavigationManager {
  final LoginPresenter presenter;

  LoginPage(this.presenter, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          handleLoading(context, presenter.isLoadingStream);
          handleMainError(context, presenter.mainErrorStream);
          handleNavigation(presenter.navigateToStream, clear: true);

          return GestureDetector(
            onTap: () => hideKeyboard(context),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const LoginHeader(),
                  Headline1(text: R.string.login),
                  Padding(
                    padding: const EdgeInsets.all(25),
                    child: ListenableProvider(
                      create: (_) => presenter,
                      child: const Form(
                        child: Column(
                          children: <Widget>[
                            UserInput(),
                            SizedBox(height: 10),
                            PasswordInput(),
                            SizedBox(height: 10),
                            UrlCcsInput(),
                            SizedBox(height: 20),
                            LoginButton(),
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
