import 'package:flutter/material.dart';

import './splash.dart';

class SplashPage extends StatelessWidget {
  final SplashPresenter presenter;

  const SplashPage({super.key, required this.presenter});

  @override
  Widget build(BuildContext context) {
    presenter.checkApiSaleRequest();

    return Scaffold(
      appBar: AppBar(title: const Text('Celta restaurante')),
      body: Builder(
        builder: (context) {
          // handleNavigation(presenter.navigateToStream, clear: true);

          return Image.asset(
            key: const Key("loading"),
            'lib/ui/assets/images/aguarde.gif',
          );
        },
      ),
    );
  }
}
