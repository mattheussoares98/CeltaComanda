import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../ui/helpers/helpers.dart';
import '../../../../components/components.dart';
import '../../../pages.dart';

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
    CommentsPresenter commentsPresenter = Provider.of(context, listen: false);
    CartPresenter cartPresenter = Provider.of(context, listen: false);

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
          padding: const EdgeInsets.only(top: 0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Divider(
                thickness: 0.1,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ImageWidget(
                    ean: null,
                    plu: product.PluChild.toString(),
                    showLargeImageInShowDialog: true,
                    height: 70,
                    width: 70,
                    beginAnimation: 1,
                    endAnimation: 0.7,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 65,
                    child: Text(
                      product.ChildName!,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        fontSize: hasMinWidth(context) ? 23 : 16,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  FittedBox(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Qtd: ${combox.Quantity.toString().toBrazilianNumber()}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: hasMinWidth(context) ? 20 : 15,
                          ),
                        ),
                        // Text(
                        //   (productCompositionPresenter
                        //               .calculateProductPrice(combox) *
                        //           combox.Quantity.toString().toDouble())
                        //       .toString()
                        //       .toBrazilianNumber()
                        //       .addBrazilianCoin(),
                        //   textAlign: TextAlign.end,
                        //   style: TextStyle(
                        //     color: Theme.of(context).colorScheme.primary,
                        //     fontWeight: FontWeight.bold,
                        //     fontSize: hasMinWidth(context) ? 20 : 15,
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
              Comment(
                comments: combox.commentFather,
                productName: combox.ChildName!,
                updateComment: () async {
                  await cartPresenter.updateCommentOfCombox(
                    indexOfCombox: widget.indexOfConfirmedCombox,
                    indexOfProduct: productIndex,
                    newComment:
                        commentsPresenter.getConcatenateSelectedComments(),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
