import 'dart:async';

import 'package:provider/provider.dart';

import '../../helpers/helpers.dart';
import '../../mixins/mixins.dart';
import '../pages.dart';

import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  const CartPage({
    super.key,
  });

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage>
    with UIErrorManager, LoadingManager {
  StreamSubscription? loadingSubscription;
  StreamSubscription? mainErrorSubscription;
  StreamSubscription? homeLoadingSubscription;

  @override
  void dispose() {
    super.dispose();
    loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();
    homeLoadingSubscription?.cancel();
  }

  final double _buttonsHeight = 50;

  @override
  Widget build(BuildContext context) {
    CartPresenter cartPresenter = Provider.of(context);

    loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();

    loadingSubscription = handleLoading(context, cartPresenter.isLoadingStream);
    mainErrorSubscription =
        handleMainError(context, cartPresenter.mainErrorStream);

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: EdgeInsets.only(bottom: _buttonsHeight),
            child: SingleChildScrollView(
                child: cartPresenter.cartProducts.isNotEmpty == true
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5.0),
                            child: Container(
                              width: double.infinity,
                              color: Theme.of(context).primaryColorDark,
                              child: const Center(
                                  child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(
                                  "CARRINHO",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )),
                            ),
                          ),
                          if (cartPresenter.cartProducts.isNotEmpty)
                            const CartProductsItems(),
                        ],
                      )
                    : const EmptyCart()),
          ),
        ),
        Visibility(
          visible: cartPresenter.cartProducts.isNotEmpty,
          child: Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              height: _buttonsHeight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    const Expanded(
                      flex: 4,
                      child: AddMoreCartItensButton(),
                    ),
                    SizedBox(width: hasMinWidth(context) ? 20 : 5),
                    const Expanded(
                      flex: 6,
                      child: SaveSaleRequestButton(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
