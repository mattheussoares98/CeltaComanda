import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

import '../../../../ui/components/components.dart';
import '../../../../ui/helpers/helpers.dart';
import '../../pages.dart';

class PrintedItem extends StatefulWidget {
  final PrintedViewModel printed;
  final GlobalKey<FormState> formKey;
  final TextEditingController personalizedCodeController;
  final TextEditingController passwordController;

  const PrintedItem({
    required this.printed,
    required this.formKey,
    required this.personalizedCodeController,
    required this.passwordController,
    super.key,
  });

  @override
  State<PrintedItem> createState() => _PrintedItemState();
}

class _PrintedItemState extends State<PrintedItem> {
  Future<void> _removeProduct({
    required PrintedProductsPresenter printedProductsPresenter,
    required MenuPresenter menuPresenter,
    required CartPresenter cartPresenter,
    required HomePresenter homePresenter,
    required ExpansibleGroupFromProductPresenter
        expansibleGroupFromProductPresenter,
    required String saleRequestProductId,
  }) async {
    await printedProductsPresenter.removeProduct(
      saleRequestProductId: saleRequestProductId,
      menuPresenter: menuPresenter,
      cartPresenter: cartPresenter,
      homePresenter: homePresenter,
      expansibleGroupFromProductPresenter: expansibleGroupFromProductPresenter,
      printedProductsPresenter: printedProductsPresenter,
    );
    setState(() {});
  }

  final double rightMargin = 2;

  @override
  Widget build(BuildContext context) {
    PrintedProductsPresenter printedProductsPresenter =
        Provider.of(context, listen: false);
    MenuPresenter menuPresenter = Provider.of(context, listen: false);
    CartPresenter cartPresenter = Provider.of(context, listen: false);
    HomePresenter homePresenter = Provider.of(context, listen: false);
    ExpansibleGroupFromProductPresenter expansibleGroupFromProductPresenter =
        Provider.of(context, listen: false);

    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: ListView.builder(
        itemCount: widget.printed.Products.length,
        itemBuilder: (context, index) {
          return Builder(builder: (context) {
            final product = widget.printed.Products[index];
            return Container(
              width: (MediaQuery.of(context).size.width /
                      getItensPerLine(context)) -
                  rightMargin,
              margin: const EdgeInsets.all(1),
              padding: EdgeInsets.only(right: rightMargin),
              decoration: BoxDecoration(
                color: Colors.white,
                border:
                    Border.all(color: const Color.fromARGB(255, 220, 218, 218)),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 10,
                    color: Color(0x33000000),
                    offset: Offset(-3, -1),
                  )
                ],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  ProductDetails(
                    printed: widget.printed,
                    product: product.Products,
                    onPressedRemoveProduct: () async {
                      notificationDialog(
                        context: context,
                        titleMessage: R.string.removeProduct,
                        content: Text(
                          R.string.wantRemoveRequestedProduct,
                          textAlign: TextAlign.center,
                        ),
                        onPress: () async {
                          await _removeProduct(
                            printedProductsPresenter: printedProductsPresenter,
                            menuPresenter: menuPresenter,
                            cartPresenter: cartPresenter,
                            homePresenter: homePresenter,
                            saleRequestProductId: product.SaleRequestProductId,
                            expansibleGroupFromProductPresenter:
                                expansibleGroupFromProductPresenter,
                          );
                        },
                      );
                    },
                    validateUserAndCancelProducts: () {
                      validateUserAndCancelProductDialog(
                          context: context,
                          formKey: widget.formKey,
                          personalizedCodeController:
                              widget.personalizedCodeController,
                          passwordController: widget.passwordController,
                          printedProductsPresenter: printedProductsPresenter,
                          callSetState: () {
                            setState(() {});
                          });
                    },
                    quantity: product.Quantity,
                    value: (product.TotalLiquid.toDouble() /
                            product.Quantity.toDouble())
                        .toString()
                        .toBrazilianNumber(),
                    totalLiquid: product.TotalLiquid,
                    comments: product.Comments,
                  ),
                  // Text("DateHourOfCreation ${product.DateHourOfCreation}"),
                  // Text(
                  //     "SaleRequestProductId ${product.SaleRequestProductId}"),
                  // Text("Quantity ${product.Quantity}"),
                  // Text("UserId ${product.UserId}"),
                  // Text("IsCancelled ${product.IsCancelled}"),
                  // Text("IsDelivered ${product.IsDelivered}"),
                  // Text("IsPrinted ${product.IsPrinted}"),
                  // Text("ProductionStatus ${product.ProductionStatus}"),
                  // Text(
                  //     "ProductInternalCodeOnErp ${product.ProductInternalCodeOnErp}"),
                  // Text("SaleRequestId ${product.SaleRequestId}"),
                ],
              ),
            );
          });
        },
      ),
      /* Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text("Comanda: ${printed.PersonalizedCode}"),
              // Text("DateHourOfCreation: ${printed.DateHourOfCreation}"),
              // Text("DateOfCreation: ${printed.DateOfCreation}"),
              // Text("DeliveryControl: ${printed.DeliveryControl}"),
              // Text("EnterpriseId: ${printed.EnterpriseId}"),
              // Text("FlagOrigin: ${printed.FlagOrigin}"),
              // Text("FlagStatus: ${printed.FlagStatus}"),
              // Text("IsCancelled: ${printed.IsCancelled}"),
              // Text("IsUsing: ${printed.IsUsing}"),
              // Text("Peoples: ${printed.Peoples}"),
              // Text("RequestType: ${printed.RequestType}"),
              // Text("SaleRequestId: ${printed.SaleRequestId}"),
            ],
          ),
        ],
      ), */
    );
  }
}
