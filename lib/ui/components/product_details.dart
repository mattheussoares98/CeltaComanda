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
  final void Function()? onPressedReduceQuantity;
  final void Function()? onPressedAddQuantity;
  final bool isPrintedProducts;

  const ProductDetails({
    required this.nameComplete,
    required this.name,
    required this.eanCode,
    required this.plu,
    required this.saleRetailPraticed,
    required this.comments,
    required this.totalLiquid,
    required this.quantity,
    required this.onPressedReduceQuantity,
    required this.onPressedAddQuantity,
    required this.isPrintedProducts,
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
              if (!isPrintedProducts)
                _UpdateQuantity(
                  onPressedReduceQuantity: onPressedReduceQuantity,
                  quantity: quantity,
                  onPressedAddQuantity: onPressedAddQuantity,
                  saleRetailPraticed: saleRetailPraticed,
                  totalLiquid: totalLiquid,
                ),
              if (isPrintedProducts)
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Preço $saleRetailPraticed R\$"),
                    Text("Total $totalLiquid R\$"),
                    TextButton.icon(
                      label: const Text(
                        "Remover",
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                      onPressed: () {},
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    ),
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

class _UpdateQuantity extends StatelessWidget {
  const _UpdateQuantity({
    required this.onPressedReduceQuantity,
    required this.quantity,
    required this.onPressedAddQuantity,
    required this.saleRetailPraticed,
    required this.totalLiquid,
  });

  final void Function()? onPressedReduceQuantity;
  final String quantity;
  final void Function()? onPressedAddQuantity;
  final String saleRetailPraticed;
  final String totalLiquid;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          height: 30,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey[300],
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.delete,
                ),
                iconSize: 20,
                visualDensity: VisualDensity.compact,
                onPressed: onPressedReduceQuantity,
                color: const Color(0xFFFF5963),
              ),
              Text(quantity),
              IconButton(
                icon: const Icon(
                  Icons.add,
                ),
                iconSize: 20,
                visualDensity: VisualDensity.compact,
                onPressed: onPressedAddQuantity,
                color: const Color(0xFFFF5963),
              ),
            ],
          ),
        ),
        Text("Preço $saleRetailPraticed R\$"),
        Text("Total $totalLiquid R\$"),
      ],
    );
  }
}
