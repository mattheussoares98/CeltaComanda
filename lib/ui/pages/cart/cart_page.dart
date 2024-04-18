import '../../pages/pages.dart';
import '../../mixins/mixins.dart';

import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  final CartPresenter presenter;

  const CartPage(this.presenter, {super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> with LoadingManager {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF1F5F8),
        title: const Text("Carrinho"),
      ),
      body: SingleChildScrollView(
        primary: false,
        child: Builder(
          builder: (context) {
            handleLoading(context, widget.presenter.isLoadingStream);

            return StreamBuilder<List<ProductsViewModel>>(
                stream: widget.presenter.cartProducts,
                builder: (context, snapshot) {
                  // if (snapshot.hasError) {
                  //   return ReloadScreen(
                  //     error: '${snapshot.error}',
                  //     reload: () async => await widget.presenter.load(),
                  //   );
                  // }
                  if (snapshot.hasData) {
                    return CartItems(productViewModel: snapshot.data!);
                  }
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          widget.presenter.addProductInCart(const ProductsViewModel(
                            image: "image",
                            price: "price",
                            name: "name",
                            plu: "plu",
                          ));
                        },
                        child: const Text("Adicionar produto"),
                      ),
                    ],
                  );
                });
          },
        ),
      ),
    );
  }
}
