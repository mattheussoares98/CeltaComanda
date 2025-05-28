import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../data/models/models.dart';
import '../../pages.dart';

class SalesDetails extends StatefulWidget {
  const SalesDetails({super.key});

  @override
  State<SalesDetails> createState() => _SalesDetailsState();
}

class _SalesDetailsState extends State<SalesDetails> {
  int? selectedIndex;

  void updateSelectedIndex(int index) {
    if (index == selectedIndex) {
      setState(() {
        selectedIndex = null;
      });
    } else {
      setState(() {
        selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SaleMovementPresenter saleMovementPresenter =
        Provider.of(context, listen: false);

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: StreamBuilder<List<SaleMovementConcentratorModel>?>(
        stream: saleMovementPresenter.salesStream,
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            selectedIndex = null;
            return SizedBox();
          }

          final pdvs = snapshot.data!.map((e) => e.PdvNumber).toSet().toList();
          pdvs.sort((a, b) => a!.compareTo(b!));

          return ListView.builder(
            shrinkWrap: true,
            itemCount: pdvs.length,
            itemBuilder: (context, index) {
              final pdv = pdvs[index];

              final salesByPdv = snapshot.data!
                  .where((e) => e.PdvNumber == pdv && e.IsCancelled != true)
                  .toList();

              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Column(
                  children: [
                    TotalByPdv(
                      index: index,
                      updateSelectedIndex: updateSelectedIndex,
                      pdv: pdv,
                      sales: salesByPdv,
                    ),
                    if (index == selectedIndex)
                      SalesByFinalizations(
                        salesByPdv: salesByPdv,
                        pdvIndex: index,
                      ),
                    if (index == pdvs.length - 1)
                      TotalAddingAllPdvs(sales: snapshot.data!),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
