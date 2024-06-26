import 'dart:async';

import 'package:get/get.dart';

import '../../../domain/entities/entities.dart';
import '../../components/components.dart';
import '../../mixins/mixins.dart';
import '../pages.dart';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({
    super.key,
  });

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage>
    with LoadingManager, UIErrorManager {
  ExpansibleGroupEntity? expansibleGroupEntity;

  bool _isLoaded = false;
  @override
  void didChangeDependencies() async {
    if (Get.arguments != null) {
      expansibleGroupEntity = Get.arguments as ExpansibleGroupEntity;
    }

    super.didChangeDependencies();
    if (!_isLoaded) {
      _isLoaded = true;
      ProductsPresenter productsPresenter = Provider.of(context);
      Future.delayed(Duration.zero, () async {
        await productsPresenter.load(expansibleGroupEntity?.ExpansibleGroupId);
      });
    }
  }

  StreamSubscription? loadingSubscription;
  StreamSubscription? mainErrorSubscription;
  @override
  void dispose() {
    super.dispose();
    loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    HomePresenter homePresenter = Provider.of(context, listen: false);
    ProductsPresenter productsPresenter = Provider.of(context);

    loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();

    loadingSubscription =
        handleLoading(context, productsPresenter.isLoadingStream);
    mainErrorSubscription =
        handleMainError(context, productsPresenter.mainErrorStream);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(expansibleGroupEntity?.Name ?? ""),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "Comanda ${homePresenter.commandNumber}",
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        primary: false,
        child: StreamBuilder<List<ProductsViewModel>>(
            stream: productsPresenter.productsStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return ReloadScreen(
                  error: '${snapshot.error}',
                  reload: () async => await productsPresenter
                      .load(expansibleGroupEntity!.ExpansibleGroupId),
                );
              }
              // if (snapshot.hasData) {
              //   return ProductsItems(
              //     products: snapshot.data!,
              //     itensPerLine: 1,
              //     updateSelectedProductWhenClick: false,
              //     selectedProduct: null,
              //   );
              // }
              return const SizedBox(height: 0);
            }),
      ),
    );
  }
}
