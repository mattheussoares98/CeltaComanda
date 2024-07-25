import 'package:flutter/material.dart';

import '../../../components/components.dart';
import '../../../helpers/helpers.dart';
import '../../pages.dart';

class FixedFatherDetails extends StatefulWidget {
  final ProductCompositionViewModel father;
  final Function() callSetState;
  final ProductsViewModel selectedComboxProduct;

  const FixedFatherDetails({
    super.key,
    required this.father,
    required this.callSetState,
    required this.selectedComboxProduct,
  });

  @override
  State<FixedFatherDetails> createState() => _FixedFatherDetailsState();
}

class _FixedFatherDetailsState extends State<FixedFatherDetails> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10, left: 10),
          child: SizedBox(
            height: 100,
            width: 100,
            child: ImageWidget(
              height: 100,
              width: 100,
              ean: null,
              plu: widget.father.PluChild!,
              isAlcoholic: false,
            ),
          ),
        ),
        const SizedBox(width: 30),
        Expanded(
          flex: 8,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (widget.father.ChildName != null)
                Text(
                  widget.father.ChildName!,
                  style: TextStyle(
                    fontSize: getStringSize(context) * 1.3,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColorDark,
                  ),
                ),
              if (widget.father.Quantity != null)
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text(
                    "Quantidade: ${widget.father.Quantity!.toBrazilianNumber()}",
                    style: TextStyle(
                      fontSize: getStringSize(context) * 0.9,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),

              // if (commentsPresenter.productHasComment(
              //   internalCodeOnERP:
              //       widget.father.InternalCodeOnERPCodeChild!.toInt(),
              //   productName: widget.father.ChildName!,
              // ))
              //   Expanded(
              //     child: Comment(
              //       comment: widget.father.commentFather ?? "",
              //     ),
              //   ),
            ],
          ),
        ),
      ],
    );
  }
}
