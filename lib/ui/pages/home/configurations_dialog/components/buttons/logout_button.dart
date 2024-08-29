import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../components/components.dart';
import '../../../../../helpers/helpers.dart';
import '../../../../pages.dart';

class LogoutButton extends StatelessWidget {
  final void Function()? resetDropdownsErrors;
  final Future<bool> Function(HomePresenter homePresenter)
      validateUserCredentials;
  const LogoutButton({
    required this.resetDropdownsErrors,
    required this.validateUserCredentials,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    CartPresenter cartPresenter = Provider.of(context, listen: false);
    HomePresenter homePresenter = Provider.of(context, listen: false);
    PrintedProductsPresenter printedProductsPresenter =
        Provider.of(context, listen: false);
    MenuPresenter menuPresenter = Provider.of(context, listen: false);

    return ElevatedButton(
      child: Padding(
        padding: EdgeInsets.all(hasMinWidth(context) ? 8.0 : 0),
        child: FittedBox(
          child: Text(
            R.string.doLogout,
            style: TextStyle(
              fontSize: getStringSize(context),
            ),
          ),
        ),
      ),
      onPressed: () async {
        if (resetDropdownsErrors != null) {
          resetDropdownsErrors!();
        }

        bool isValidCredentials = await validateUserCredentials(homePresenter);

        if (isValidCredentials) {
          if (cartPresenter.cartProducts.isNotEmpty) {
            Future.delayed(Duration.zero, () {
              notificationDialog(
                  context: context,
                  titleMessage: R.string.clearCart,
                  content: Text(R.string.msgClearCartOnLogout),
                  onPress: () async {
                    cartPresenter.clearCart();
                    await homePresenter.goToSplashPage(
                      printedProductsPresenter: printedProductsPresenter,
                      cartPresenter: cartPresenter,
                      menuPresenter: menuPresenter,
                    );
                  });
            });
          } else {
            await homePresenter.goToSplashPage(
              printedProductsPresenter: printedProductsPresenter,
              cartPresenter: cartPresenter,
              menuPresenter: menuPresenter,
            );
          }
        }
      },
    );
  }
}
