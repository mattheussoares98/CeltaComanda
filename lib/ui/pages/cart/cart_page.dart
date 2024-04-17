
import '../../pages/pages.dart';
import '../../mixins/mixins.dart';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class CartPage extends StatefulWidget {
  final CartPresenter presenter;

  const CartPage(this.presenter, {super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage>
    with KeyboardManager, LoadingManager, UIErrorManager {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF1F5F8),
        automaticallyImplyLeading: false,
        title: const Text("Carrinho"),
      ),
      body: SingleChildScrollView(
        primary: false,
        child: Builder(
          builder: (context) {
            handleLoading(context, widget.presenter.isLoadingStream);

            return StreamBuilder<List<CartViewModel>>(
                stream: widget.presenter.cartProducts,
                builder: (context, snapshot) {
                  // if (snapshot.hasError) {
                  //   return ReloadScreen(
                  //     error: '${snapshot.error}',
                  //     reload: () async => await widget.presenter.load(),
                  //   );
                  // }
                  if (snapshot.hasData) {
                    return ListenableProvider(
                      create: (_) => widget.presenter,
                      child: CartItems(cartViewModel: snapshot.data!),
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
