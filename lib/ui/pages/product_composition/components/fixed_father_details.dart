import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../helpers/helpers.dart';
import '../../pages.dart';

class FixedFatherDetails extends StatefulWidget {
  final ProductCompositionViewModel father;
  final Function() callSetState;

  const FixedFatherDetails({
    super.key,
    required this.father,
    required this.callSetState,
  });

  @override
  State<FixedFatherDetails> createState() => _FixedFatherDetailsState();
}

class _FixedFatherDetailsState extends State<FixedFatherDetails> {
  final GlobalKey _tooltipKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    CartPresenter cartPresenter = Provider.of(context, listen: false);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (widget.father.ChildName != null)
              Expanded(
                child: Text(
                  widget.father.ChildName!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: hasMinWidth(context) ? 40 : 20,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColorDark,
                  ),
                ),
              ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (widget.father.Quantity != null)
              Text(
                "Quantidade: ${widget.father.Quantity!.toBrazilianNumber()}",
                style: TextStyle(
                  fontSize: hasMinWidth(context) ? 23 : 12,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w300,
                ),
              ),
            Text(
              cartPresenter
                  .calculateProductTotalLiquid(widget.father)
                  .toString()
                  .toBrazilianNumber()
                  .addBrazilianCoin(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
                fontSize: hasMinWidth(context) ? 23 : 15,
              ),
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
              AddCommentButton(
                father: widget.father,
                callSetState: () {
                  widget.callSetState();
                },
              ),
            ],
          ),
      ],
    );
  }
}
