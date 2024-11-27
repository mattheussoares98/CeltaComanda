import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/components.dart';
import '../../../helpers/helpers.dart';
import '../../pages.dart';

class TotalByPerson extends StatefulWidget {
  const TotalByPerson({super.key});

  @override
  State<TotalByPerson> createState() => _TotalByPersonState();
}

class _TotalByPersonState extends State<TotalByPerson> {
  int selectedPeoples = 1;
  double totalPerPerson = 0;

  @override
  void initState() {
    super.initState();

    PrintedProductsPresenter printedProductsPresenter =
        Provider.of(context, listen: false);

    _updateTotalPerPerson(printedProductsPresenter);
  }

  void _updateTotalPerPerson(
      PrintedProductsPresenter printedProductsPresenter) {
    totalPerPerson = printedProductsPresenter
            .getTotalLiquid(printedProductsPresenter.printed) /
        selectedPeoples;
  }

  @override
  Widget build(BuildContext context) {
    PrintedProductsPresenter printedProductsPresenter = Provider.of(
        context); //need listen to update total by person correctly when remove service charge
    HomePresenter homePresenter = Provider.of(context, listen: false);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              R.string.peopleQuantity,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: getStringSize(context)),
            ),
            const SizedBox(height: 10),
            FittedBox(
              child: UpdateQuantity(
                quantity: selectedPeoples,
                reduceQuantity: () {
                  setState(() {
                    selectedPeoples--;
                    _updateTotalPerPerson(printedProductsPresenter);
                  });
                },
                addQuantity: () {
                  setState(() {
                    selectedPeoples++;
                    _updateTotalPerPerson(printedProductsPresenter);
                  });
                },
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "${R.string.totalByPerson}: ${(printedProductsPresenter.getTotalLiquid(printedProductsPresenter.printed) / selectedPeoples).toString().toBrazilianNumber().addBrazilianCoin()}",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: getStringSize(context)),
            ),
            if (!homePresenter.isFixedCommandNumber)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: ElevatedButton(
                  onPressed: () async {
                    writeCommandNumber(
                      context: context,
                      onWriteCommandAction: OnWriteCommand.loadPrintedProducts,
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(3),
                    child: FittedBox(
                      child: Text(
                        R.string.searchDataOfOtherCommandNumber,
                        style: TextStyle(
                          fontSize: getStringSize(context),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
