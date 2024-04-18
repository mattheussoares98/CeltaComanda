import 'package:provider/provider.dart';

import '../../../presentation/presenters/presenters.dart';
import '../../pages/pages.dart';
import '../../mixins/mixins.dart';

import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> with LoadingManager {
  @override
  Widget build(BuildContext context) {
    GetxCartPresenter cartPresenter = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF1F5F8),
        title: const Text("Carrinho"),
      ),
      body: SingleChildScrollView(
        primary: false,
        child: Builder(
          builder: (context) {
            handleLoading(context, cartPresenter.isLoadingStream);

            return Column(
              children: [
                CartItems(productViewModel: cartPresenter.cartProducts),
                ElevatedButton(
                  onPressed: ()async {
                    await cartPresenter.addProductInCart(const ProductsViewModel(
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
          },
        ),
      ),
    );
  }
}
