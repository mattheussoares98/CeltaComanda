import 'package:flutter/material.dart';

class ProductDetails extends StatelessWidget {
  final String? nameComplete;
  final String name;
  final String? eanCode;
  final String plu;
  final String saleRetailPraticed;
  final String? comments;
  final String totalLiquid;
  final String quantity;
  final String saleRequestProductId;

  const ProductDetails({
    required this.nameComplete,
    required this.name,
    required this.eanCode,
    required this.plu,
    required this.saleRetailPraticed,
    required this.comments,
    required this.totalLiquid,
    required this.quantity,
    required this.saleRequestProductId,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nameComplete != null ? nameComplete! : name,
                    ),
                    if (eanCode != null)
                      Text(
                        "EAN: ${eanCode!}",
                      ),
                    Text(
                      "PLU: $plu",
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Preço $saleRetailPraticed R\$"),
                  Row(
                    children: [
                      Text("Qtd: $quantity"),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        visualDensity: VisualDensity.compact,
                      ),
                    ],
                  ),
                  Text("Total $totalLiquid R\$"),
                ],
              ),
            ],
          ),
          if (comments != null) Text("Comentário: $comments")
        ],
      ),
    );
  }
}
