import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/components.dart';
import '../../../helpers/helpers.dart';
import '../../pages.dart';

class LoadedProductsItems extends StatefulWidget {
  final PrintedViewModel? printedViewModel;
  const LoadedProductsItems({
    required this.printedViewModel,
    super.key,
  });

  @override
  State<LoadedProductsItems> createState() => _LoadedProductsItemsState();
}

class _LoadedProductsItemsState extends State<LoadedProductsItems> {
  void updateProductIsSelected({
    required SendProductsToAnotherTablePresenter
        sendProductsToAnotherTablePresenter,
    required PrintedProductsViewModel product,
  }) {
    setState(() {
      sendProductsToAnotherTablePresenter.updateProductIsSelected(
        product.SaleRequestProductId.toInt(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    SendProductsToAnotherTablePresenter sendProductsToAnotherTablePresenter =
        Provider.of(context, listen: false);

    return Builder(builder: (context) {
      if (widget.printedViewModel == null) {
        return Center(
          child: Text(
            "origin table is empty" + "",
            style: TextStyle(
              fontSize: getStringSize(context),
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
        );
      }
      if (widget.printedViewModel == null) {
        return SizedBox();
      }
      return Padding(
        padding: const EdgeInsets.all(8),
        child: GridView.builder(
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: hasMinWidth(context) ? 3 : 1,
            childAspectRatio: 8,
            mainAxisSpacing: 5,
            crossAxisSpacing: 5,
          ),
          itemCount: widget.printedViewModel!.Products.length,
          itemBuilder: (context, index) {
            widget.printedViewModel!.Products.sort(
                (a, b) => a.DateHourOfCreation.compareTo(b.DateHourOfCreation));

            final product = widget.printedViewModel!.Products[index];

            DateTime data = DateTime.parse(product.DateHourOfCreation);
            String horasEMinutos =
                "${data.hour.toString().padLeft(2, '0')}:${data.minute.toString().padLeft(2, '0')}";

            return InkWell(
              onTap: () {
                updateProductIsSelected(
                  sendProductsToAnotherTablePresenter:
                      sendProductsToAnotherTablePresenter,
                  product: product,
                );
              },
              child: Container(
                color: Theme.of(context).primaryColorLight.withAlpha(30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Text(horasEMinutos),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                          children: [
                            Expanded(
                              child: Text(
                                product.Product.Name,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: getStringSize(context),
                                ),
                              ),
                            ),
                            if (product.Comments != null)
                              FittedBox(
                                child: Comment(comment: product.Comments!),
                              ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Text(
                        product.TotalLiquid.toDouble()
                            .toString()
                            .toBrazilianNumber()
                            .addBrazilianCoin(),
                      ),
                    ),
                    Checkbox(
                      value: sendProductsToAnotherTablePresenter
                          .selectedsSaleRequestProductsIds
                          .contains(
                        product.SaleRequestProductId.toInt(),
                      ),
                      onChanged: (value) {
                        updateProductIsSelected(
                          sendProductsToAnotherTablePresenter:
                              sendProductsToAnotherTablePresenter,
                          product: product,
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    });
  }
}
