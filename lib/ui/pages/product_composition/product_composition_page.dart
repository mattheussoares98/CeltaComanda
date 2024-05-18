import 'package:provider/provider.dart';

import 'dart:async';
import 'package:flutter/material.dart';

import '../../mixins/mixins.dart';
import 'product_composition_presenter.dart';

class ProductCompositionPage extends StatefulWidget {
  final ProductCompositionPresenter presenter;

  const ProductCompositionPage(this.presenter, {super.key});

  @override
  State<ProductCompositionPage> createState() => _ProductCompositionPageState();
}

class _ProductCompositionPageState extends State<ProductCompositionPage>
    with KeyboardManager, LoadingManager, UIErrorManager {
  bool _isLoaded = false;
  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (!_isLoaded) {
      _isLoaded = true;
      await widget.presenter.loadProductComposition();
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

          return GestureDetector(
            onTap: () => hideKeyboard(context),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(25),
                    child: ListenableProvider(
                      create: (_) => widget.presenter,
                      child: const Form(
                        child: Column(
                          children: [],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
