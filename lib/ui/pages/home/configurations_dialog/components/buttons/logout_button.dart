import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../components/components.dart';
import '../../../../../helpers/helpers.dart';
import '../../../../pages.dart';

class LogoutButton extends StatelessWidget {
  final GlobalKey<FormState> validationKey;
  final TextEditingController userPersonalizedCode;
  final TextEditingController userPassword;
  final Function() resetDropdownsErrors;
  const LogoutButton({
    required this.validationKey,
    required this.userPassword,
    required this.userPersonalizedCode,
    required this.resetDropdownsErrors,
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
        resetDropdownsErrors();
        FocusScope.of(context).unfocus();

        if (validationKey.currentState?.validate() != true) {
          return;
        }

        bool isValidUserAndPassword =
            await homePresenter.isValidUserAndPassword(
          personalizedCode: userPersonalizedCode.text.toInt(),
          password: userPassword.text,
        );

        if (isValidUserAndPassword) {
          if (cartPresenter.cartProducts.isNotEmpty) {
            Future.delayed(Duration.zero, () {
              notificationDialog(
                  context: context,
                  titleMessage: R.string.clearCart,
                  content: Text(R.string.msgClearCartOnLogout),
                  onPress: () async {
                    if (isValidUserAndPassword) {
                      cartPresenter.clearCart();
                      await homePresenter.goToSplashPage(
                        printedProductsPresenter: printedProductsPresenter,
                        cartPresenter: cartPresenter,
                        menuPresenter: menuPresenter,
                      );
                    }
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
