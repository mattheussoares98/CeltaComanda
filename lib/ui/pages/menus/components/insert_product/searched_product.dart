// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../domain/entities/entities.dart';
import '../../../../components/components.dart';
import '../../../../helpers/helpers.dart';
import '../../../pages.dart';

class SearchedProduct extends StatefulWidget {
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

  @override
  State<SearchedProduct> createState() => _SearchedProductState();
}

class _SearchedProductState extends State<SearchedProduct> {
  final formKeyQuantity = GlobalKey<FormState>();
  final formKeyCommandNumber = GlobalKey<FormState>();
  final commentFocusNode = FocusNode();
  final quantityFocusNode = FocusNode();

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
        writtedComment: widget.commentController.text,
        product: CartProductEntity(
          Product: product.toEntity(),
          Comments: widget.commentController.text,
          TotalLiquid: product.SaleRetailPraticed.toDouble() *
              widget.quantityController.text.toDouble(),
          Quantity: widget.quantityController.text.toDouble(),
          Value: product.SaleRetailPraticed.toDouble(),
          ProductPriceLookUpCode: product.PriceLookupCode,
        ),
        menuPresenter: menuPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
      );
      widget.quantityController.clear();
      widget.commentController.clear();
      PersonalizedDialogPage.open(
        context: context,
        page: const CartPage(),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();

    commentFocusNode.dispose();
    quantityFocusNode.dispose();
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
      margin: const EdgeInsets.only(top: 15),
      padding: const EdgeInsets.all(10),
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
            ProductInformations(product: widget.product),
            QuantityField(
              product: widget.product,
              quantityController: widget.quantityController,
              commentFocusNode: commentFocusNode,
              quantityFocusNode: quantityFocusNode,
            ),
            const SizedBox(height: 8),
            CommentField(
              product: widget.product,
              commentFocusNode: commentFocusNode,
              commentController: widget.commentController,
              addProduct: () async {
                await addProduct(
                  menuPresenter,
                  cartPresenter,
                  homePresenter,
                  printedProductsPresenter,
                  expansibleGroupFromProductPresenter,
                  widget.product,
                  context,
                );
              },
            ),
            Form(
              key: formKeyCommandNumber,
              child: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: ElevatedButton(
                  onPressed: widget.product.IsPromoCombox == "true"
                      ? null
                      : () async {
                          await addProduct(
                            menuPresenter,
                            cartPresenter,
                            homePresenter,
                            printedProductsPresenter,
                            expansibleGroupFromProductPresenter,
                            widget.product,
                            context,
                          );
                        },
                  child: Text(R.string.confirm),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
