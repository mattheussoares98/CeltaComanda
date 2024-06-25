import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../pages.dart';
import '../../../../components/components.dart';

class ConfirmedComboxItem extends StatefulWidget {
  final ConfirmedComboxViewModel confirmedCombox;
  final int indexOfConfirmedCombox;
  const ConfirmedComboxItem({
    required this.confirmedCombox,
    required this.indexOfConfirmedCombox,
    super.key,
  });

  @override
  State<ConfirmedComboxItem> createState() => _ConfirmedComboxItemState();
}

class _ConfirmedComboxItemState extends State<ConfirmedComboxItem> {
  TextEditingController commentsController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    commentsController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ProductCompositionPresenter productCompositionPresenter =
        Provider.of(context, listen: false);

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.confirmedCombox.products.length,
      itemBuilder: (context, productIndex) {
        final combox = widget.confirmedCombox.products[productIndex];

        ProductCompositionViewModel product;
        if (combox.childs?.isNotEmpty == true &&
            combox.indexOfSelectedChild != null) {
          product = combox.childs![combox.indexOfSelectedChild!];
        } else {
          product = combox;
        }

        return Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ImageWidget(
                    ean: null,
                    plu: product.PluChild.toString(),
                    showLargeImageInShowDialog: true,
                    height: 30,
                    width: 30,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 65,
                    child: Text(
                      product.ChildName!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  FittedBox(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "Qtd: ${combox.Quantity.toString().toBrazilianNumber()}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          (productCompositionPresenter
                                      .calculateProductPrice(combox) *
                                  combox.Quantity.toString().toDouble())
                              .toString()
                              .toBrazilianNumber()
                              .addBrazilianCoin(),
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Comment(
                comments: combox.commentFather,
              ),
            ],
          ),
        );
      },
    );
  }
}
