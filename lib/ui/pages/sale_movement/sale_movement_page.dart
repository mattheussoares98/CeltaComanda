import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../helpers/helpers.dart';
import '../../mixins/mixins.dart';
import '../pages.dart';

class SaleMovementPage extends StatefulWidget {
  const SaleMovementPage({super.key});

  @override
  State<SaleMovementPage> createState() => _SaleMovementPageState();
}

class _SaleMovementPageState extends State<SaleMovementPage>
    with UIErrorManager, LoadingManager {
  StreamSubscription? loadingSubscription;
  StreamSubscription? errorSubscription;

  @override
  void dispose() {
    super.dispose();
    loadingSubscription?.cancel();
    errorSubscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    SaleMovementPresenter saleMovementPresenter =
        Provider.of(context, listen: false);
    HomePresenter homePresenter = Provider.of(context, listen: false);

    loadingSubscription?.cancel();
    errorSubscription?.cancel();
    loadingSubscription =
        handleLoading(context, saleMovementPresenter.isLoadingStream);
    errorSubscription =
        handleMainError(context, saleMovementPresenter.mainErrorStream);

    return Scaffold(
      appBar: AppBar(
        title: Text(
            "${R.string.sales}  ${homePresenter.commandEntity?.pdv?.PdvNumber != null ? "${R.string.pdv} ${homePresenter.commandEntity!.pdv!.PdvNumber!}" : ""}"),
      ),
      body: const Padding(
        padding: EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              UpdateDateAndSearchSalesButtons(),
              SalesDetails(),
            ],
          ),
        ),
      ),
    );
  }
}
