import 'package:flutter/material.dart';

import '../../../../data/models/models.dart';
import '../../../helpers/helpers.dart';

class TotalByPdv extends StatelessWidget {
  final int index;
  final void Function(int index) updateSelectedIndex;
  final String? pdv;
  final List<SaleMovementConcentratorModel> sales;

  const TotalByPdv({
    required this.index,
    required this.updateSelectedIndex,
    required this.pdv,
    required this.sales,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final salesByPdv = sales.where((e) => e.PdvNumber == pdv).toList();

    final totalByPdv = salesByPdv.fold<double>(0.0, (previous, element) {
      return previous += element.TotalLiquid!;
    });

    return Container(
      margin: EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: index % 2 == 0
            ? Theme.of(context).primaryColor.withAlpha(35)
            : Theme.of(context).primaryColor.withAlpha(15),
      ),
      child: InkWell(
        onTap: () {
          updateSelectedIndex(index);
        },
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("${R.string.pdv.toUpperCase()} $pdv"),
              Text(
                totalByPdv.toString().toBrazilianNumber().addBrazilianCoin(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
