import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../helpers/helpers.dart';
import '../../mixins/mixins.dart';
import '../pages.dart';

class CancelProductsPage extends StatefulWidget {
  const CancelProductsPage({super.key});

  @override
  State<CancelProductsPage> createState() => _CancelProductsPageState();
}

class _CancelProductsPageState extends State<CancelProductsPage>
    with LoadingManager, UIErrorManager {
  StreamSubscription? loadingSubscription;
  StreamSubscription? mainErrorSubscription;

  @override
  dispose() {
    super.dispose();

    loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    PrintedProductsPresenter printedProductsPresenter = Provider.of(
      context,
      listen: false,
    );
    HomePresenter homePresenter = Provider.of(
      context,
      listen: false,
    );

    loadingSubscription =
        handleLoading(context, printedProductsPresenter.isLoadingStream);
    mainErrorSubscription =
        handleMainError(context, printedProductsPresenter.mainErrorStream);

    return Scaffold(
      appBar: AppBar(
        title: Text(R.string.cancel),
      ),
      body: Column(
        children: [
          DropdownButton(
            value: homePresenter.commandNumber?.toInt(),
            items: List<int>.generate(
              100,
              (int index) => index++,
              growable: true,
            )
                .map(
                  (e) => DropdownMenuItem(
                    value: e + 1,
                    onTap: () async {
                      await printedProductsPresenter.loadPrinted(homePresenter);
                    },
                    child: Text(
                      (e + 1).toString(),
                    ),
                  ),
                )
                .toList(),
            onChanged: (value) async {
              await printedProductsPresenter.loadPrinted(homePresenter);
            },
          ),
          if (printedProductsPresenter.printedProducts != null) Products(),
        ],
      ),
    );
  }
}
