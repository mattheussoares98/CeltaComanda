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
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Builder(
                builder: (context) {
                  handleLoading(context, cartPresenter.isLoadingStream);

                  return CartItems(
                      productViewModel: cartPresenter.cartProducts);
                },
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              // fixedSize: const Size(double.infinity, 60),
              minimumSize: const Size(double.infinity, 40),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: const BorderSide(
                  color: Color(0xFFE0E3E7),
                ),
              ),
            ),
            onPressed: () {},
            child: const Text(
              'Salvar pedido',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
