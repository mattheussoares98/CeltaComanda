import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../domain/entities/entities.dart';
import '../../helpers/helpers.dart';
import '../../mixins/mixins.dart';
import '../pages.dart';

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
      ),
      body: StreamBuilder<List<EnterpriseEntity>?>(
          stream: webAllEnterprisesPresenter.enterprisesStream,
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return Center(
                child: TextButton(
                    onPressed: () async {
                      await webAllEnterprisesPresenter.loadEnterprises();
                    },
                    child: Text(R.string.search)),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final enterprise = snapshot.data![index];

                return Text(enterprise.enterpriseName);
              },
            );
          }),
    );
  }
}
