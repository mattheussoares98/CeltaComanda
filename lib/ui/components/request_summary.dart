import 'package:clean_celta_mobile/ui/pages/pages.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RequestSummary extends StatelessWidget {
  final String totalLiquid;
  final String? comments;
  const RequestSummary({
    required this.totalLiquid,
    required this.comments,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    PrintedProductsPresenter printedProductsPresenter =
        Provider.of(context, listen: true);

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
              ),
              Text("$totalLiquid R\$"),
            ],
          ),
          const SizedBox(height: 10),
          if (printedProductsPresenter.printedProducts?.Comments != null)
            Text(
                "Comentário: ${printedProductsPresenter.printedProducts!.Comments!}"),
        ],
      ),
    );
  }
}
