import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../helpers/helpers.dart';
import '../../mixins/mixins.dart';
import '../pages.dart';
import 'components/components.dart';

class WebAllEnterprisesPage extends StatefulWidget {
  const WebAllEnterprisesPage({super.key});

  @override
  State<WebAllEnterprisesPage> createState() => _WebAllEnterprisesPageState();
}

class _WebAllEnterprisesPageState extends State<WebAllEnterprisesPage>
    with LoadingManager, UIErrorManager {
  StreamSubscription? loadingSubscription;
  StreamSubscription? mainErrorSubscription;

  @override
  dispose() {
    loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WebAllEnterprisesPresenter webAllEnterprisesPresenter =
        Provider.of(context, listen: false);

    loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();
    loadingSubscription = handleLoading(
      context,
      webAllEnterprisesPresenter.isLoadingStream,
    );
    mainErrorSubscription = handleMainError(
      context,
      webAllEnterprisesPresenter.mainErrorStream,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(R.string.enterprises),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: IconButton(
              onPressed: () async {
                //TODO create option to add new enterprise
              },
              icon: Icon(Icons.add),
            ),
          ),
          IconButton(
            onPressed: () async {
              await webAllEnterprisesPresenter.loadEnterprises();
            },
            icon: Icon(Icons.refresh),
          ),
        ],
      ),
      body: Enterprises(),
    );
  }
}
