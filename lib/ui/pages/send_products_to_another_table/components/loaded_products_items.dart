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
  @override
  Widget build(BuildContext context) {
    SendProductsToAnotherTablePresenter sendProductsToAnotherTablePresenter =
        Provider.of(context, listen: false);

    return Builder(builder: (context) {
      if (widget.printedViewModel == null) {
        return Center(
          child: Text(
            R.string.originTableIsEmpty,
            style: TextStyle(
              fontSize: StringSize.size,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
        );
      }
      if (widget.printedViewModel == null) {
        return SizedBox();
      }
      return ListView.builder(
        shrinkWrap: true,
        itemCount: widget.printedViewModel!.Products.length,
        itemBuilder: (context, index) {
          final product = widget.printedViewModel!.Products[index];

          DateTime data = DateTime.parse(product.DateHourOfCreation!);
          String horasEMinutos =
              "${data.hour.toString().padLeft(2, '0')}:${data.minute.toString().padLeft(2, '0')}";

          return Padding(
            padding: const EdgeInsets.only(top: 4),
            child: InkWell(
              onTap: () {
                setState(() {
                  sendProductsToAnotherTablePresenter
                      .updateProductIsSelected(index);
                });
              },
              child: Container(
                color: product.IsCancelled == "true"
                    ? Colors.red
                    : Theme.of(context).primaryColorLight.withAlpha(
                        sendProductsToAnotherTablePresenter.selectedProducts
                                    ?.contains(product) ==
                                true
                            ? 75
                            : 30),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Text(horasEMinutos),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: ProductName(product: product),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: Text(
                                  product.TotalLiquid!
                                      .toDouble()
                                      .toString()
                                      .toBrazilianNumber()
                                      .addBrazilianCoin(),
                                ),
                              ),
                            ],
                          ),
                          if (product.Comments != null &&
                              product.Comments!.isNotEmpty)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              child: Comment(comment: product.Comments!),
                            ),
                        ],
                      ),
                    ),
                    if (product.IsCancelled != "true")
                      Checkbox(
                        value: sendProductsToAnotherTablePresenter
                            .selectedProducts
                            ?.contains(product),
                        onChanged: (_) {
                          setState(() {
                            sendProductsToAnotherTablePresenter
                                .updateProductIsSelected(index);
                          });
                        },
                      )
                  ],
                ),
              ),
            ),
          );
        },
      );
    });
  }
}
