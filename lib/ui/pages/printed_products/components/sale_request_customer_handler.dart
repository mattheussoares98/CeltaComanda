import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/components.dart';
import '../../../helpers/helpers.dart';
import '../../pages.dart';

class SaleRequestCustomerHandler extends StatelessWidget {
  const SaleRequestCustomerHandler({super.key});
  String getCustomerDescription(
      PrintedProductsPresenter printedProductsPresenter) {
    final customer = printedProductsPresenter.customerInSaleRequest;

    String value = "\n${customer?.Name}"
        "\n${R.string.code} (${customer?.Code})";

    if (customer?.Code != customer?.PersonalizedCode) {
      value += "\n${R.string.personalizedCode} (${customer?.PersonalizedCode})";
    }

    return value;
  }

  @override
  Widget build(BuildContext context) {
    PrintedProductsPresenter printedProductsPresenter =
        Provider.of(context, listen: false);

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 3, vertical: 10),
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).primaryColorLight,
                blurRadius: 10,
              )
            ],
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            border: Border.all(
              color: Theme.of(context).primaryColorLight.withAlpha(30),
            )),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              RichText(
                text: TextSpan(
                    style: TextStyle(
                      color: Theme.of(context).primaryColorDark,
                      fontSize: StringSize.size,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
                    text: R.string.selectedCustomer,
                    children: [
                      TextSpan(
                        text: getCustomerDescription(printedProductsPresenter),
                        style: TextStyle(
                          color: Theme.of(context)
                              .primaryColorLight, //TODO if customer is not null, dont search again when load sale request
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ]),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: ElevatedButton(
                  onPressed: () {
                    PersonalizedDialogPage.open(
                      context: context,
                      page: InsertCustomerPage(),
                    );
                  },
                  child: Text(
                    printedProductsPresenter.customerInSaleRequest == null
                        ? R.string.addCustomer
                        : R.string.changeCustomer,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
