import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../home/home.dart';
import './splash.dart';

class SplashPage extends StatefulWidget {
  final SplashPresenter presenter;

  const SplashPage({super.key, required this.presenter});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    HomePresenter homePresenter = Provider.of(context, listen: false);
    widget.presenter.checkPageToGo(homePresenter: homePresenter);
  }

  @override
  Widget build(BuildContext context) {
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
