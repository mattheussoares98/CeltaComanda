// ignore_for_file: non_constant_identifier_names

import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

import '../pages/pages.dart';

class ProductItem extends StatefulWidget {
  final ProductsViewModel product;
  final Future Function() updateProductQuantity;
  final void Function()? goToComboxPage;
  final TextEditingController productCommentController;
  const ProductItem({
    required this.product,
    required this.updateProductQuantity,
    required this.goToComboxPage,
    required this.productCommentController,
    super.key,
  });

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  bool _showCommentFormField = false;

  @override
  Widget build(BuildContext context) {
    SaleRequestTempPresenter saleRequestTempPresenter = Provider.of(context);

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(8, 0, 8, 8),
      child: Container(
        padding: const EdgeInsets.all(8),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              blurRadius: 3,
              color: Color(0x411D2429),
              offset: Offset(
                0.0,
                1,
              ),
            )
          ],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ImageWidget(
                  ean: widget.product.EanCode,
                  plu: widget.product.PriceLookupCode,
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.product.Name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        "PLU ${widget.product.PriceLookupCode}",
                      ),
                      if (widget.product.EanCode != null)
                        Text(
                          "EAN ${widget.product.EanCode!}",
                        ),
                    ],
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'R\$ ${widget.product.SaleRetailPraticed}',
                      textAlign: TextAlign.end,
                    ),
                    if (_productQuantityInSaleRequestTemp(
                            saleRequestTempPresenter: saleRequestTempPresenter,
                            product: widget.product) >
                        0)
                      RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                                text: _productQuantityInSaleRequestTemp(
                                        saleRequestTempPresenter:
                                            saleRequestTempPresenter,
                                        product: widget.product)
                                    .toString(),
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                )),
                            const TextSpan(
                              text: ' pendente(s)',
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                    if (widget.product.IsPromoCombox == "true")
                      TextButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          padding: const EdgeInsets.all(3),
                        ),
                        onPressed: widget.goToComboxPage,
                        child: const Text("Montar\ncombo"),
                      ),
                    if (widget.product.IsPromoCombox == "false")
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _showCommentFormField = !_showCommentFormField;
                              });
                            },
                            icon: const Icon(
                              Icons.add_comment,
                              color: Colors.green,
                              size: 30,
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              maximumSize: const Size(30, 30),
                              minimumSize: const Size(30, 30),
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              padding: const EdgeInsets.all(0),
                            ),
                            onPressed: () async {
                              await widget.updateProductQuantity();
                            },
                            child: const FittedBox(
                                child:
                                    Text("+1", style: TextStyle(fontSize: 14))),
                          ),
                        ],
                      ),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                if (_showCommentFormField)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: TextFormField(
                        maxLines: null,
                        decoration: const InputDecoration(
                          hintText: "Comentário",
                          label: Text("Comentário"),
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 3,
                            horizontal: 8,
                          ),
                        ),
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

int _productQuantityInSaleRequestTemp({
  required SaleRequestTempPresenter saleRequestTempPresenter,
  required ProductsViewModel product,
}) {
  return saleRequestTempPresenter.saleRequestTemp?.Products
          .where((element) =>
              element.Product.PriceLookupCode == product.PriceLookupCode)
          .length ??
      0;
}
