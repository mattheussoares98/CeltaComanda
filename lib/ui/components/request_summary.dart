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
          if (printedProductsPresenter.printedProducts?.Comments != null)
            RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: "Comentário: ",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  TextSpan(
                    text: printedProductsPresenter.printedProducts!.Comments!,
                    style: const TextStyle(
                      color: Colors.red,
                      fontStyle: FontStyle.italic,
                      fontSize: 17,
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Text(
                "$totalLiquid R\$",
                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
