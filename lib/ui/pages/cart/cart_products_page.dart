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

  final double _buttonHeight = 65;

  @override
  Widget build(BuildContext context) {
    CartPresenter cartPresenter = Provider.of(context);

    loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();

    loadingSubscription = handleLoading(context, cartPresenter.isLoadingStream);
    mainErrorSubscription =
        handleMainError(context, cartPresenter.mainErrorStream);

    return SafeArea(
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Padding(
              padding: EdgeInsets.only(bottom: _buttonHeight),
              child: cartPresenter.cartProducts.isNotEmpty == true
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5.0),
                          child: Container(
                            width: double.infinity,
                            color: Theme.of(context).primaryColorDark,
                            child: Center(
                                child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                R.string.cart.toUpperCase(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: getStringSize(context),
                                ),
                              ),
                            )),
                          ),
                        ),
                        if (cartPresenter.cartProducts.isNotEmpty)
                          Expanded(child: const CartProductsItems()),
                      ],
                    )
                  : const EmptyCart(),
            ),
          ),
          Visibility(
            visible: cartPresenter.cartProducts.isNotEmpty,
            child: Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: SizedBox(
                height: _buttonHeight,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: AddMoreCartItensButton(
                          buttonHeight: _buttonHeight,
                        ),
                      ),
                      SizedBox(width: hasMinWidth(context) ? 20 : 5),
                      Expanded(
                        flex: 6,
                        child: SaveSaleRequestButton(
                          buttonHeight: _buttonHeight,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
