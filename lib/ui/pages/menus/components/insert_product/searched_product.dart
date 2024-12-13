// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../domain/entities/entities.dart';
import '../../../../components/components.dart';
import '../../../../helpers/helpers.dart';
import '../../../pages.dart';

class SearchedProduct extends StatelessWidget {
  final ProductsViewModel product;
  final TextEditingController commandNumberController;
  final TextEditingController quantityController;
  final TextEditingController commentController;

  const SearchedProduct({
    required this.product,
    required this.commandNumberController,
    required this.quantityController,
    required this.commentController,
    super.key,
  });
  static final formKeyQuantity = GlobalKey<FormState>();
  static final formKeyCommandNumber = GlobalKey<FormState>();
  static final commentFocusNode = FocusNode();

  Future<void> addProduct(
    MenuPresenter menuPresenter,
    CartPresenter cartPresenter,
    HomePresenter homePresenter,
    PrintedProductsPresenter printedProductsPresenter,
    ExpansibleGroupFromProductPresenter expansibleGroupFromProductPresenter,
    ProductsViewModel product,
    BuildContext context,
  ) async {
    bool? isValid = formKeyQuantity.currentState?.validate();

    if (isValid == true) {
      await cartPresenter.addProductInCart(
        writtedComment: commentController.text,
        product: CartProductEntity(
          Product: product.toEntity(),
          Comments: commentController.text,
          TotalLiquid: product.SaleRetailPraticed.toDouble() *
              quantityController.text.toDouble(),
          Quantity: quantityController.text.toDouble(),
          Value: product.SaleRetailPraticed.toDouble(),
          ProductPriceLookUpCode: product.PriceLookupCode,
        ),
        menuPresenter: menuPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );
      quantityController.clear();
      commentController.clear();
      PersonalizedDialogPage.open(
        context: context,
        page: CartPage(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    MenuPresenter menuPresenter = Provider.of(context, listen: false);
    CartPresenter cartPresenter = Provider.of(context, listen: false);
    HomePresenter homePresenter = Provider.of(context, listen: false);
    ExpansibleGroupFromProductPresenter expansibleGroupFromProductPresenter =
        Provider.of(context, listen: false);
    PrintedProductsPresenter printedProductsPresenter =
        Provider.of(context, listen: false);

    return Container(
      margin: EdgeInsets.only(top: 15),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Theme.of(context).primaryColorLight,
          )),
      width: double.infinity,
      child: Form(
        key: formKeyQuantity,
        child: Column(
          children: [
            ProductInformations(product: product),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      QuantityField(
                        product: product,
                        quantityController: quantityController,
                        commentFocusNode: commentFocusNode,
                      ),
                      const SizedBox(height: 8),
                      CommentField(
                        product: product,
                        commentFocusNode: commentFocusNode,
                        commentController: commentController,
                        addProduct: () async {
                          await addProduct(
                            menuPresenter,
                            cartPresenter,
                            homePresenter,
                            printedProductsPresenter,
                            expansibleGroupFromProductPresenter,
                            product,
                            context,
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Form(
                  key: formKeyCommandNumber,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: product.IsPromoCombox == "true"
                          ? null
                          : () async {
                              await addProduct(
                                menuPresenter,
                                cartPresenter,
                                homePresenter,
                                printedProductsPresenter,
                                expansibleGroupFromProductPresenter,
                                product,
                                context,
                              );
                            },
                      child: Text(R.string.confirm),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
