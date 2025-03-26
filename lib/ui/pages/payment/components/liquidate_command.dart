import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../main/builders/builders.dart';
import '../../../components/components.dart';
import '../../pages.dart';

class LiquidateCommand extends StatelessWidget {
  final Function() callSetState;
  const LiquidateCommand({
    required this.callSetState,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    PaymentPresenter paymentPresenter = Provider.of(context, listen: false);
    PrintedProductsPresenter printedProductsPresenter =
        Provider.of(context, listen: false);
    HomePresenter homePresenter = Provider.of(context, listen: false);

    return Column(
      children: [
        Text(
          R.string.msgCommandAlreadyPaid,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: StringSize.size,
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () async {
            await paymentPresenter.liquidateCommand(
                cpfCnpj: null, //TODO receive the cofCnpj here
                printedProductsPresenter: printedProductsPresenter,
                homePresenter: homePresenter,
                showErrorMessageReturnedByBs: (error) {
                  snackBarMessage(context, error, backgroundColor: Colors.red);
                },
                showSuccessAndCloseUntilHomePage: () {
                  final correctContext =
                      NavigatorKey.navigatorKey.currentState?.context ??
                          context;
                  Navigator.of(correctContext).popUntil(
                    (route) => route.isFirst,
                  );
                  snackBarMessage(
                    correctContext,
                    R.string.liquidateCommandSucceeds,
                    backgroundColor:
                        Theme.of(correctContext).secondaryHeaderColor,
                  );
                });
            callSetState();
          },
          child: Text(
            R.string.liquidateCommand,
            style: TextStyle(
              fontSize: StringSize.size * 1.4,
            ),
          ),
        ),
      ],
    );
  }
}
