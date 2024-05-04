import 'package:clean_celta_mobile/presentation/presenters/getx_expansible_groups_presenter.dart';
import 'package:get/get.dart';

import '../../../domain/entities/entities.dart';
import '../../components/components.dart';
import '../../mixins/mixins.dart';
import './products.dart';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class ProductsPage extends StatefulWidget {
  final ProductsPresenter presenter;
  const ProductsPage(this.presenter, {super.key});

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
      Future.delayed(Duration.zero, () async {
        await widget.presenter.load(expansibleGroupEntity?.ExpansibleGroupId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (Get.arguments != null) {
      expansibleGroupEntity = Get.arguments as ExpansibleGroupEntity;
    }

    GetxExpansibleGroupsPresenter expansibleGroupsPresenter =
        Provider.of(context);

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
                  "Comanda ${expansibleGroupsPresenter.commandNumber}",
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        primary: false,
        child: Builder(
          builder: (context) {
            handleLoading(context, widget.presenter.isLoadingStream);
            handleMainError(context, widget.presenter.mainErrorStream);

            return StreamBuilder<List<ProductsViewModel>>(
                stream: widget.presenter.productsStream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return ReloadScreen(
                      error: '${snapshot.error}',
                      reload: () async => await widget.presenter
                          .load(expansibleGroupEntity!.ExpansibleGroupId),
                    );
                  }
                  if (snapshot.hasData) {
                    return ListenableProvider(
                      create: (_) => widget.presenter,
                      child: ProductsItems(products: snapshot.data!),
                    );
                  }
                  return const SizedBox(height: 0);
                });
          },
        ),
      ),
    );
  }
}
