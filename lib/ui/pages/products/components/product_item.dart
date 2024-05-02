// ignore_for_file: non_constant_identifier_names

import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/pages/pages.dart';

class ProductItem extends StatefulWidget {
  final ProductsViewModel product;
  final int indexOfProduct;
  const ProductItem({
    required this.product,
    required this.indexOfProduct,
    super.key,
  });

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  @override
  Widget build(BuildContext context) {
    GetxSaleRequestTempPresenter saleRequestTempPresenter =
        Provider.of(context, listen: false);
    ProductsPresenter productsPresenter = Provider.of(context, listen: false);

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(8, 0, 8, 8),
      child: GestureDetector(
        onTap: () {
          setState(() {
            productsPresenter
                .updateIndexOfSelectedProduct(widget.indexOfProduct);
          });
        },
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
                children: [
                  // ImageWidget(product: product),
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
                          widget.product.PriceLookupCode,
                        ),
                        if (widget.product.EanCode != null)
                          Text(
                            widget.product.EanCode!,
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
                              saleRequestTempPresenter:
                                  saleRequestTempPresenter,
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
                                text: ' no carrinho',
                                style: TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                      Icon(
                        widget.indexOfProduct ==
                                productsPresenter.indexOfSelectedProduct
                            ? Icons.arrow_drop_up_outlined
                            : Icons.arrow_drop_down,
                        color: const Color(0xFF57636C),
                        size: 24,
                      ),
                    ],
                  ),
                ],
              ),
              if (widget.indexOfProduct ==
                  productsPresenter.indexOfSelectedProduct)
                Padding(
                  key: const Key("AddCommentAndProductInCart"),
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          maxLines: null,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 5.0,
                              horizontal: 10.0,
                            ),
                            hintText: "Comentário",
                            label: Text("Comentário"),
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          String numberAmerican = widget
                              .product.SaleRetailPraticed
                              .replaceAll(RegExp(r','), '.');

                          double saleRetailPraticed =
                              double.parse(numberAmerican);

                          final entity = UpdateSaleRequestTempEntity(
                            DeliveryControl: int.parse(saleRequestTempPresenter
                                .saleRequestTemp!.DeliveryControl),
                            EnterpriseId: int.parse(saleRequestTempPresenter
                                .saleRequestTemp!.EnterpriseId),
                            PersonalizedCode: saleRequestTempPresenter
                                .saleRequestTemp!.PersonalizedCode,
                            SaleRequestTempId: int.parse(
                                saleRequestTempPresenter
                                    .saleRequestTemp!.SaleRequestTempId),
                            TotalLiquid: saleRetailPraticed,
                            Products: [
                              UpdateSaleRequestTempProductEntity(
                                ProductInternalCodeOnErp: int.parse(widget
                                    .product.InternalCodeOfProductOnERP
                                    .toString()),
                                ProductPriceLookUpCode:
                                    widget.product.PriceLookupCode,
                                Quantity: 1,
                                SaleRequestTempId: int.parse(
                                    saleRequestTempPresenter
                                        .saleRequestTemp!.SaleRequestTempId),
                                TotalLiquid: saleRetailPraticed,
                                Value: saleRetailPraticed,
                              )
                            ],
                            Comments: "comentário via aplicativo",
                          );

                          await productsPresenter.updateSaleRequest(entity);
                        },
                        child: const Text("Adicionar"),
                      ),
                    ],
                  ),
                ),
            ],
          ),
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
