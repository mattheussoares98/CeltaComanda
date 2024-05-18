import 'package:clean_celta_mobile/ui/pages/pages.dart';
import 'package:get/get.dart';

import 'dart:async';
import 'package:flutter/material.dart';

import '../../../main/builders/builders.dart';
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
                  return Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      primary: false,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final productViewModel = snapshot.data![index];

                        return Column(
                          children: [
                            if (productViewModel.ProductCompositionId != null)
                              Text(
                                "productViewModel.ProductCompositionId: ${productViewModel.ProductCompositionId}",
                              ),
                            if (productViewModel.EnterpriseId != null)
                              Text(
                                "productViewModel.EnterpriseId: ${productViewModel.EnterpriseId}",
                              ),
                            if (productViewModel.InternalCodeOnERPCodeFather !=
                                null)
                              Text(
                                "productViewModel.InternalCodeOnERPCodeFather: ${productViewModel.InternalCodeOnERPCodeFather}",
                              ),
                            if (productViewModel.InternalCodeOnERPCodeChild !=
                                null)
                              Text(
                                "productViewModel.InternalCodeOnERPCodeChild: ${productViewModel.InternalCodeOnERPCodeChild}",
                              ),
                            if (productViewModel.PluChild != null)
                              Text(
                                "productViewModel.PluChild: ${productViewModel.PluChild}",
                              ),
                            if (productViewModel.ChildName != null)
                              Text(
                                "productViewModel.ChildName: ${productViewModel.ChildName}",
                              ),
                            if (productViewModel.Quantity != null)
                              Text(
                                "productViewModel.Quantity: ${productViewModel.Quantity}",
                              ),
                            if (productViewModel.SalePrice != null)
                              Text(
                                "productViewModel.SalePrice: ${productViewModel.SalePrice}",
                              ),
                            if (productViewModel.OfferPrice != null)
                              Text(
                                "productViewModel.OfferPrice: ${productViewModel.OfferPrice}",
                              ),
                            if (productViewModel.IncrementValue != null)
                              Text(
                                "productViewModel.IncrementValue: ${productViewModel.IncrementValue}",
                              ),
                            if (productViewModel.IsOptionalItem != null)
                              Text(
                                "productViewModel.IsOptionalItem: ${productViewModel.IsOptionalItem}",
                              ),
                            if (productViewModel.ProductOptions != null)
                              Text(
                                "productViewModel.ProductOptions: ${productViewModel.ProductOptions}",
                              ),
                          ],
                        );
                      },
                    ),
                  );
                }
                return const SizedBox(height: 0);
              });
        },
      ),
    );
  }
}
