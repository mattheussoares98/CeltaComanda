import 'package:clean_celta_mobile/main/builders/builders.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

import '../../../../ui/helpers/helpers.dart';
import '../../../components/components.dart';
import '../../pages.dart';

class SaveSaleRequestButton extends StatelessWidget {
  final double buttonHeight;
  const SaveSaleRequestButton({
    required this.buttonHeight,
    super.key,
  });

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
        showAlertMessage(
          context,
          R.string.msgRequestSentSuccessfully,
        );
      });
    }
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

    TextEditingController tableNumberController = TextEditingController();
    GlobalKey<FormState> tableKey = GlobalKey<FormState>();

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: Size(double.infinity, buttonHeight),
        maximumSize: Size(double.infinity, buttonHeight),
      ),
      onPressed: () async {
        if (homePresenter.isFixedCommandNumber) {
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
          notificationDialog(
            context: context,
            titleMessage: R.string.addFlagOrTable,
            cancelMessage: R.string.jump,
            confirmMessage: R.string.confirmFlag,
            closeDialogOnConfirmPress: false,
            onCancelPress: () async {
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
            onPress: () async {
              bool? isValid = tableKey.currentState?.validate();

              if (isValid == true) {
                Navigator.of(context).pop();
                await _addProducts(
                  insertProductPresenter: insertProductPresenter,
                  cartPresenter: cartPresenter,
                  context: context,
                  printedProductsPresenter: printedProductsPresenter,
                  tableNumber: int.tryParse(tableNumberController.text),
                  homePresenter: homePresenter,
                  expansibleGroupFromProductPresenter:
                      expansibleGroupFromProductPresenter,
                );
              }
            },
            content: Row(
              children: [
                const Expanded(child: SizedBox()),
                Expanded(
                  child: Form(
                    key: tableKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: TextFormField(
                      autofocus: true,
                      controller: tableNumberController,
                      keyboardType: TextInputType.number,
                      maxLength: 4,
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        counterText: "",
                      ),
                      validator: (value) {
                        if (int.tryParse(value!) == null) {
                          return R.string.msgInvalidNumber;
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                const Expanded(child: SizedBox()),
              ],
            ),
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
