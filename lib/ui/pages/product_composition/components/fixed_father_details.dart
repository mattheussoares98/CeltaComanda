import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  final GlobalKey _tooltipKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    CartPresenter cartPresenter = Provider.of(context, listen: false);
    CommentsPresenter commentsPresenter = Provider.of(context, listen: false);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (widget.father.ChildName != null)
              Expanded(
                child: FatherNameText(name: widget.father.ChildName!),
              ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (widget.father.Quantity != null)
              QuantityText(
                quantity: widget.father.Quantity!,
              ),
            PriceText(
              quantity:
                  cartPresenter.calculateProductTotalLiquid(widget.father),
            ),
          ],
        ),
        if (widget.father.IsOptionalItem != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  final dynamic tooltip = _tooltipKey.currentState;
                  tooltip.ensureTooltipVisible();
                },
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Tooltip(
                        key: _tooltipKey,
                        message: widget.father.IsOptionalItem == "true"
                            ? "Se desejar, selecione um produto. O preço sele será somado no combo"
                            : 'Selecione pelo menos um produto',
                        child: Icon(
                          Icons.info,
                          color: Theme.of(context).secondaryHeaderColor,
                        ),
                      ),
                    ),
                    Text(
                      widget.father.IsOptionalItem == "true"
                          ? "Item opcional"
                          : "Item obrigatório",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: Theme.of(context).secondaryHeaderColor,
                        fontSize: hasMinWidth(context) ? 23 : 15,
                      ),
                    ),
                  ],
                ),
              ),
              if (commentsPresenter.productHasComment(
                internalCodeOnERP:
                    widget.father.InternalCodeOnERPCodeChild!.toInt(),
                productName: widget.father.ChildName!,
              ))
                Expanded(
                  child: Comment(
                    comment: widget.father.commentFather ?? "",
                  ),
                ),
            ],
          ),
      ],
    );
  }
}
