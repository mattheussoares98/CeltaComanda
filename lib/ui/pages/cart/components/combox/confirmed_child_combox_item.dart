import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../ui/helpers/helpers.dart';
import '../../../../components/components.dart';
import '../../../pages.dart';

class ConfirmedChildComboxItem extends StatefulWidget {
  final ConfirmedComboxViewModel confirmedCombox;
  final int indexOfConfirmedCombox;
  const ConfirmedChildComboxItem({
    required this.confirmedCombox,
    required this.indexOfConfirmedCombox,
    super.key,
  });

  @override
  State<ConfirmedChildComboxItem> createState() =>
      _ConfirmedChildComboxItemState();
}

class _ConfirmedChildComboxItemState extends State<ConfirmedChildComboxItem> {
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
    MenuPresenter menuPresenter = Provider.of(context, listen: false);

    return Column(
      children: [
        for (var index = 0;
            index < widget.confirmedCombox.products.length;
            index++)
          Builder(builder: (context) {
            final combox = widget.confirmedCombox.products[index];

            ProductCompositionViewModel product;
            if (combox.childs?.isNotEmpty == true &&
                combox.indexOfSelectedChild != null) {
              product = combox.childs![combox.indexOfSelectedChild!];
            } else {
              product = combox;
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(
                  height: 1,
                  thickness: 0.1,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 50,
                      width: 50,
                      child: GestureDetector(
                        onTap: () {
                          showLargeImage(
                            context: context,
                            ean: null,
                            plu: product.PluChild!,
                            productComplement: null,
                            menuPresenter: menuPresenter,
                            productName: product.ChildName,
                          );
                        },
                        child: ImageWidget(
                          ean: null,
                          plu: product.PluChild!,
                          height: 50,
                          width: 50,
                          isAlcoholic: false,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 65,
                      child: Text(
                        product.ChildName!,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          fontSize: getStringSize(context) * 0.8,
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
                              fontSize: getStringSize(context) * 0.8,
                            ),
                          ),
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
                      indexOfProduct: index,
                      newComment:
                          commentsPresenter.getConcatenateSelectedComments(),
                    );
                  },
                ),
              ],
            );
          })
      ],
    );
  }
}
