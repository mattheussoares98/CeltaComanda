import 'package:get/get.dart';

import 'dart:async';
import 'package:flutter/material.dart';

import '../../../main/builders/builders.dart';
import '../../../ui/pages/pages.dart';
import '../../components/components.dart';
import '../../mixins/mixins.dart';

class ProductCompositionPage extends StatefulWidget {
  final ProductCompositionPresenter presenter;

  const ProductCompositionPage(
    this.presenter, {
    super.key,
  });

  @override
  State<ProductCompositionPage> createState() => _ProductCompositionPageState();
}

class _ProductCompositionPageState extends State<ProductCompositionPage>
    with KeyboardManager, LoadingManager, UIErrorManager {
  int? internalCodeOnErp;
  bool _isLoaded = false;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (!_isLoaded) {
      _isLoaded = true;

      if (Get.arguments != null) {
        internalCodeOnErp = Get.arguments;
        Future.delayed(Duration.zero, () async {
          await widget.presenter.loadProductComposition(
            enterpriseId:
                EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId!,
            url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
            internalCodeOnErp: internalCodeOnErp!,
          );
        });
      }
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Montagem do combo"),
      ),
      body: Builder(
        builder: (context) {
          loadingSubscription =
              handleLoading(context, widget.presenter.isLoadingStream);
          mainErrorSubscription =
              handleMainError(context, widget.presenter.mainErrorStream);

          return StreamBuilder<List<ProductCompositionViewModel>>(
              stream: widget.presenter.productsCompositionStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return ReloadScreen(
                    error: '${snapshot.error}',
                    reload: () async =>
                        await widget.presenter.loadProductComposition(
                      url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
                      enterpriseId: EnterpriseDataBuilder
                          .enterpriseDataEntity!.enterpriseId!,
                      internalCodeOnErp: internalCodeOnErp!,
                    ),
                  );
                }
                if (snapshot.hasData) {
                  return FatherItems(snapshot.data!);
                }
                return const SizedBox(height: 0);
              });
        },
      ),
    );
  }
}
