import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/components.dart';
import '../../../helpers/helpers.dart';
import '../../pages.dart';

class UpdateTotalByPerson extends StatefulWidget {
  const UpdateTotalByPerson({super.key});

  @override
  State<UpdateTotalByPerson> createState() => _UpdateTotalByPersonState();
}

class _UpdateTotalByPersonState extends State<UpdateTotalByPerson> {
  int selectedPeoples = 1;
  double totalPerPerson = 0;

  @override
  void initState() {
    super.initState();

    HomePresenter homePresenter = Provider.of(context, listen: false);
    PrintedProductsPresenter printedProductsPresenter =
        Provider.of(context, listen: false);

    selectedPeoples = homePresenter.selectedPeoples ?? 1;
    _updateTotalPerPerson(printedProductsPresenter);
  }

  void _updateTotalPerPerson(
      PrintedProductsPresenter printedProductsPresenter) {
    totalPerPerson = printedProductsPresenter.totalLiquid / selectedPeoples;
  }

  @override
  Widget build(BuildContext context) {
    PrintedProductsPresenter printedProductsPresenter =
        Provider.of(context, listen: false);
    HomePresenter homePresenter = Provider.of(context, listen: false);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: Column(
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
            "${R.string.totalByPerson}: ${totalPerPerson.toString().toBrazilianNumber().addBrazilianCoin()}",
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
    );
  }
}
