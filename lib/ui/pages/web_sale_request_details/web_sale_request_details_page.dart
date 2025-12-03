import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/components.dart';
import '../../helpers/helpers.dart';
import '../../mixins/mixins.dart';
import '../pages.dart';

class WebSaleRequestDetailsPage extends StatefulWidget {
  const WebSaleRequestDetailsPage({super.key});

  @override
  State<WebSaleRequestDetailsPage> createState() =>
      _WebSaleRequestDetailsPageState();
}

class _WebSaleRequestDetailsPageState extends State<WebSaleRequestDetailsPage>
    with LoadingManager, UIErrorManager {
  StreamSubscription? loadingSubscription;
  StreamSubscription? mainErrorSubscription;
  final controller = TextEditingController();

  @override
  dispose() {
    super.dispose();

    loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider =
        Provider.of<WebSaleRequestDetailsPresenter>(context, listen: false);

    loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();
    loadingSubscription = handleLoading(context, provider.isLoadingStream);
    mainErrorSubscription = handleMainError(context, provider.mainErrorStream);

    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            controller: controller,
            decoration: formFieldDecoration(
              context: context,
              hintText: R.string.enterprise,
              labelText: R.string.enterprise,
              errorText: null,
            ),
          ),
          const SizedBox(
            height: 32,
          ),
          ElevatedButton(
            onPressed: () {
              provider.validateEnterprise();
            },
            child: Text(R.string.validateEnterprise),
          )
        ],
      ),
    ));
  }
}
