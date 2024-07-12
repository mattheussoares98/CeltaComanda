import 'dart:async';

import 'package:provider/provider.dart';

import '../../../ui/helpers/helpers.dart';
import '../../mixins/mixins.dart';
import '../pages.dart';

import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  final PageController? pageController;
  final bool? isFixedCommandNumber;
  const CartPage({
    this.pageController,
    this.isFixedCommandNumber,
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

    return Scaffold(
      body: SafeArea(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Padding(
                padding: EdgeInsets.only(bottom: _buttonsHeight),
                child: SingleChildScrollView(
                  child: cartPresenter.cartProducts.isNotEmpty == true ||
                          cartPresenter.confirmedCombox.isNotEmpty == true
                      ? Column(
                          children: [
                            if (cartPresenter.cartProducts.isNotEmpty)
                              CartProductsItems(
                                cartProducts: cartPresenter.cartProducts,
                                itensPerLine: hasMinWidth(context) ? 3 : 2,
                              ),
                            if (cartPresenter.confirmedCombox.isNotEmpty)
                              ConfirmedChildAndFatherItems(
                                confirmedsCombox: cartPresenter.confirmedCombox,
                                itensPerLine: 2,
                              ),
                          ],
                        )
                      : SizedBox(
                          height: MediaQuery.of(context).size.height -
                              AppBar().preferredSize.height -
                              kBottomNavigationBarHeight,
                          width: double.infinity,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FittedBox(
                                child: Text(
                                  "O carrinho está vazio",
                                  style: TextStyle(
                                    fontSize: hasMinWidth(context) ? 30 : 20,
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20.0),
                                child: Image.asset(
                                  key: const Key("emptyCartKey"),
                                  "lib/ui/assets/images/empty_cart.jpg",
                                ),
                              ),
                              ElevatedButton.icon(
                                onPressed: () {
                                  if (widget.pageController != null) {
                                    widget.pageController!.jumpToPage(0);
                                  }
                                },
                                label: Text(
                                  "Adicionar itens",
                                  style: TextStyle(
                                    fontSize: hasMinWidth(context) ? 25 : 20,
                                  ),
                                ),
                                icon: Icon(
                                  Icons.shopping_cart,
                                  size: hasMinWidth(context) ? 30 : 20,
                                ),
                              )
                            ],
                          ),
                        ),
                ),
              ),
            ),
            Visibility(
              visible: cartPresenter.cartProducts.length +
                      cartPresenter.confirmedCombox.length >
                  0,
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
                        if (widget.pageController != null)
                          Expanded(
                            flex: 4,
                            child: AddMoreCartItensButton(
                              pageController: widget.pageController!,
                            ),
                          ),
                        if (widget.pageController != null)
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
        ),
      ),
    );
  }
}
