import 'package:clean_celta_mobile/ui/pages/products/components/products_items.dart';

import '../../mixins/mixins.dart';
import './products.dart';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class ProductsPage extends StatefulWidget {
  final ProductsPresenter presenter;
  const ProductsPage({required this.presenter, super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage>
    with LoadingManager, NavigationManager {
  bool _isLoaded = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isLoaded) {
      _isLoaded = true;
      widget.presenter.loadProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Produtos"),
        backgroundColor: Theme.of(context).colorScheme.primary,
        // actions: [
        //   CartIcon(presenter: ),
        // ],
      ),
      body: SingleChildScrollView(
        primary: false,
        child: Builder(
          builder: (context) {
            handleNavigation(widget.presenter.navigateToStream);

            return StreamBuilder<List<ProductsViewModel>>(
                stream: widget.presenter.productsStream,
                builder: (context, snapshot) {
                  // if (snapshot.hasError) {
                  //   return ReloadScreen(
                  //     error: '${snapshot.error}',
                  //     reload: () async =>
                  //         await widget.presenter.loadExpansibleGroups(),
                  //   );
                  // }
                  if (snapshot.hasData) {
                    return ListenableProvider(
                      create: (_) => widget.presenter,
                      child: ProductsItems(productsViewModel: snapshot.data!),
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
