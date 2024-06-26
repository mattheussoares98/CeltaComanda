import 'dart:async';

import 'package:provider/provider.dart';

import '../../components/components.dart';
import '../pages.dart';
import '../../mixins/mixins.dart';

import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

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

  @override
  Widget build(BuildContext context) {
    CartPresenter cartPresenter = Provider.of(context);
    MenuPresenter menuPresenter = Provider.of(context, listen: false);
    PrintedProductsPresenter printedProductsPresenter =
        Provider.of(context, listen: false);
    HomePresenter homePresenter = Provider.of(context, listen: false);

    loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();

    loadingSubscription = handleLoading(context, cartPresenter.isLoadingStream);
    mainErrorSubscription =
        handleMainError(context, cartPresenter.mainErrorStream);

    return Scaffold(
      drawer: drawer(
        context: context,
        menuPresenter: menuPresenter,
        printedProductsPresenter: printedProductsPresenter,
        cartPresenter: cartPresenter,
        homePresenter: homePresenter,
      ),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40),
        child: AppBar(
          backgroundColor: const Color(0xFFF1F5F8),
          leading: IconButton(
            icon: Icon(
              Icons.exit_to_app,
              color: Theme.of(context).primaryColor,
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 45.0),
              child: SingleChildScrollView(
                child: cartPresenter.cartProducts.isNotEmpty == true ||
                        cartPresenter.confirmedCombox.isNotEmpty == true
                    ? Column(
                        children: [
                          if (cartPresenter.cartProducts.isNotEmpty)
                            CartProductsItems(
                              cartProducts: cartPresenter.cartProducts,
                            ),
                          if (cartPresenter.confirmedCombox.isNotEmpty)
                            ConfirmedComboxItems(
                              confirmedsCombox: cartPresenter.confirmedCombox,
                            ),
                        ],
                      )
                    : SizedBox(
                        height: MediaQuery.of(context).size.height -
                            AppBar().preferredSize.height -
                            kBottomNavigationBarHeight,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: FittedBox(
                                  child: Text(
                                "O carrinho está vazio",
                                style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic,
                                ),
                              )),
                            ),
                            Image.asset(
                              key: const Key("emptyCartKey"),
                              "lib/ui/assets/images/empty_cart.jpg",
                              width: double.infinity,
                            ),
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
            child: const Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: SaveSaleRequestButton(),
            ),
          ),
        ],
      ),
    );
  }
}
