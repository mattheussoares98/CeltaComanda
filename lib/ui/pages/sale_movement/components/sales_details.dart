import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
      child: StreamBuilder(
        stream: saleMovementPresenter.salesStream,
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return SizedBox();
          }

          final pdvs = snapshot.data!.map((e) => e.PdvNumber).toSet().toList();
          pdvs.sort((a, b) => a!.compareTo(b!));

          return ListView.builder(
            shrinkWrap: true,
            itemCount: pdvs.length,
            itemBuilder: (context, index) {
              final pdv = pdvs[index];

              return Column(
                children: [
                  TotalByPdv(
                    index: index,
                    updateSelectedIndex: updateSelectedIndex,
                    pdv: pdv,
                    sales: snapshot.data!,
                  ),
                  if (index == selectedIndex)
                    Text(
                      "initializate view of informations about one determinated pdv",
                    ),
                  if (index == pdvs.length - 1)
                    TotalAddingAllPdvs(sales: snapshot.data!),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
