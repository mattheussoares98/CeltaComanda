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
    final presenter = Provider.of<GetxExpansibleGroupsPresenter>(context);
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
                  handleLoading(context, presenter.isLoadingStream);

                  if (presenter.saleRequestTemp != null) {
                    return CartItems(
                        productViewModel: presenter.saleRequestTemp!);
                  }
                  return const Text("Não há dados");
                },
              ),
            ),
          ),
          const SaveSaleRequestButton(),
        ],
      ),
    );
  }
}
