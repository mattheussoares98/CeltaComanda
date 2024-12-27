import 'package:flutter/material.dart';

import '../../../../data/models/models.dart';
import '../../../../ui/helpers/helpers.dart';

class SalesByFinalizations extends StatelessWidget {
  final List<SaleMovementConcentratorModel> salesByPdv;
  const SalesByFinalizations({
    required this.salesByPdv,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final finalizationsByPdv =
        salesByPdv.expand((e) => e.Finalizations).map((x) => x).toList();

    final finalizationsTypes =
        finalizationsByPdv.map((e) => e.finalizationType).toSet().toList();

    return ListView.builder(
      shrinkWrap: true,
      itemCount: finalizationsTypes.length,
      itemBuilder: (context, finalizationsTypesIndex) {
        final finalizationType = finalizationsTypes[finalizationsTypesIndex];

        final finalizationsByType = finalizationsByPdv
            .where((e) => e.finalizationType == finalizationType)
            .toList();

        return Row(
          children: [
            Expanded(child: Text(finalizationType.name)),
            Text(
              finalizationsByType
                  .map((e) => e.ValueLiquid!)
                  .fold(0.0, (previous, element) {
                    return previous += element;
                  })
                  .toString()
                  .toBrazilianNumber()
                  .addBrazilianCoin(),
            ),
          ],
        );
      },
    );
  }
}
