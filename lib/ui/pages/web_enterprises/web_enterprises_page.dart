import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../helpers/helpers.dart';
import '../../mixins/mixins.dart';
import '../pages.dart';
import 'web_enterprises_components/web_enterprises_components.dart';

class WebEnterprisesPage extends StatefulWidget {
  const WebEnterprisesPage({super.key});

  @override
  State<WebEnterprisesPage> createState() => _WebEnterprisesPageState();
}

class _WebEnterprisesPageState extends State<WebEnterprisesPage>
    with LoadingManager, UIErrorManager {
  StreamSubscription? loadingSubscription;
  StreamSubscription? mainErrorSubscription;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        await Provider.of<WebEnterprisesPresenter>(context, listen: false)
            .loadEnterprises();
      }
    });
  }

  @override
  dispose() {
    loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WebEnterprisesPresenter webEnterprisesPresenter =
        Provider.of(context, listen: false);

    loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();
    loadingSubscription = handleLoading(
      context,
      webEnterprisesPresenter.isLoadingStream,
    );
    mainErrorSubscription = handleMainError(
      context,
      webEnterprisesPresenter.mainErrorStream,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(R.string.enterprises),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: IconButton(
              onPressed: () async {
                webEnterprisesPresenter.goToAddOrEditEnterprise(null);
              },
              icon: Icon(Icons.add),
            ),
          ),
          IconButton(
            onPressed: () async {
              await webEnterprisesPresenter.loadEnterprises();
            },
            icon: Icon(Icons.refresh),
          ),
        ],
      ),
      body: Enterprises(),
    );
  }
}
