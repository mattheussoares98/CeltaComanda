import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../home/home.dart';
import './splash.dart';

class SplashPage extends StatelessWidget {
  final SplashPresenter presenter;

  const SplashPage({super.key, required this.presenter});

  @override
  Widget build(BuildContext context) {
    HomePresenter homePresenter = Provider.of(context, listen: false);

    presenter.checkPageToGo(homePresenter: homePresenter);

    return Scaffold(
      body: Center(
        child: Image.asset(
          key: const Key("loading"),
          'lib/ui/assets/images/aguarde.gif',
        ),
      ),
    );
  }
}
