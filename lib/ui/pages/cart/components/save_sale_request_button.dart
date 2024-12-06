// ignore_for_file: use_build_context_synchronously

import 'package:clean_celta_mobile/main/builders/builders.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

import '../../../helpers/helpers.dart';
import '../../../components/components.dart';
import '../../pages.dart';

class SaveSaleRequestButton extends StatefulWidget {
  final double buttonHeight;
  const SaveSaleRequestButton({
    required this.buttonHeight,
    super.key,
  });

  @override
  State<SaveSaleRequestButton> createState() => _SaveSaleRequestButtonState();
}

class _SaveSaleRequestButtonState extends State<SaveSaleRequestButton> {
  TextEditingController commandNumberController = TextEditingController();
  GlobalKey<FormState> commandNumberKey = GlobalKey<FormState>();

  _addProducts({
    required CartPresenter cartPresenter,
    required PrintedProductsPresenter printedProductsPresenter,
    required ExpansibleGroupFromProductPresenter
        expansibleGroupFromProductPresenter,
    required BuildContext context,
    required HomePresenter homePresenter,
    required int? tableNumber,
    required InsertProductPresenter insertProductPresenter,
    String? commandNumber,
  }) async {
    bool isUpdated = await cartPresenter.saveProducts(
      printedProductsPresenter: printedProductsPresenter,
      tableNumber: tableNumber,
      commandNumber: commandNumber,
      homePresenter: homePresenter,
      expansibleGroupFromProductPresenter: expansibleGroupFromProductPresenter,
      insertProductPresenter: insertProductPresenter,
    );

    if (isUpdated) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        Navigator.of(NavigatorKey.navigatorKey.currentState!.context).pop();
        snackBarMessage(
          context,
          R.string.msgRequestSentSuccessfully,
        );
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    commandNumberController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CartPresenter cartPresenter = Provider.of(context, listen: true);
    HomePresenter homePresenter = Provider.of(context, listen: false);
    InsertProductPresenter insertProductPresenter =
        Provider.of(context, listen: false);
    ExpansibleGroupFromProductPresenter expansibleGroupFromProductPresenter =
        Provider.of(context, listen: false);
    PrintedProductsPresenter printedProductsPresenter =
        Provider.of(context, listen: false);

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: Size(double.infinity, widget.buttonHeight),
        maximumSize: Size(double.infinity, widget.buttonHeight),
      ),
      onPressed: () async {
        commandNumberController.clear();

        if (homePresenter.commandEntity?.isFixedCommandNumber == true) {
          notificationDialog(
            context: context,
            titleMessage: R.string.sendRequest,
            content: Text(
              R.string.msgWhenConfirmProductsAreRequestAndSoonIncome,
              style: TextStyle(
                fontSize: hasMinWidth(context) ? 23 : 17,
              ),
            ),
            cancelMessage: R.string.turnBack,
            confirmMessage: R.string.send,
            onPress: () async {
              await _addProducts(
                insertProductPresenter: insertProductPresenter,
                cartPresenter: cartPresenter,
                context: context,
                printedProductsPresenter: printedProductsPresenter,
                tableNumber: null,
                homePresenter: homePresenter,
                expansibleGroupFromProductPresenter:
                    expansibleGroupFromProductPresenter,
              );
            },
          );
        } else {
          writeCommandNumber(
            context: context,
            onWriteCommandAction: OnWriteCommand.saveProducts,
          );
        }
      },
      child: FittedBox(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FittedBox(
              child: Text(
                R.string.sendRequest,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: getStringSize(context),
                ),
              ),
            ),
            SizedBox(width: hasMinWidth(context) ? 100 : 5),
            FittedBox(
              child: Text(
                cartPresenter
                    .getTotalSaleRequestTempPrice(insertProductPresenter),
                style: TextStyle(
                  fontSize: getStringSize(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
