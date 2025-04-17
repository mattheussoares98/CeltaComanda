import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'components.dart';
import '../helpers/helpers.dart';
import '../pages/pages.dart';

class TotalByPerson extends StatefulWidget {
  const TotalByPerson({super.key});

  @override
  State<TotalByPerson> createState() => _TotalByPersonState();
}

class _TotalByPersonState extends State<TotalByPerson> {
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
        printedProductsPresenter.peopleQuantity;
  }

  @override
  Widget build(BuildContext context) {
    PrintedProductsPresenter printedProductsPresenter = Provider.of(
        context); //need listen to update total by person correctly when remove service charge
    HomePresenter homePresenter = Provider.of(context, listen: false);

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.4,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (printedProductsPresenter.printed == null)
            Expanded(
              child: Text(
                R.string.msgCommandDontHaveOpenValues,
                style: TextStyle(
                  color: Theme.of(context).primaryColorLight,
                  fontSize: StringSize.size,
                ),
              ),
            ),
          if (printedProductsPresenter.printed != null)
            Expanded(
              flex: 6,
              child: Column(
                children: [
                  Expanded(
                    child: FittedBox(
                      child: Text(
                        R.string.peopleQuantity,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: StringSize.size),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    flex: 3,
                    child: UpdateQuantity(
                      quantity:
                          printedProductsPresenter.peopleQuantity.toDouble(),
                      reduceQuantity: () {
                        setState(() {
                          printedProductsPresenter.updatePeopleQuantity(
                            isAdding: false,
                          );
                        });
                      },
                      addQuantity: () {
                        setState(() {
                          printedProductsPresenter.updatePeopleQuantity(
                            isAdding: true,
                          );
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: FittedBox(
                      child: Text(
                        "${R.string.totalByPerson}: ${(printedProductsPresenter.getTotalLiquid(printedProductsPresenter.printed) / printedProductsPresenter.peopleQuantity).toString().toBrazilianNumber().addBrazilianCoin()}",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: StringSize.size),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          if (homePresenter.commandEntity?.isFixedCommandNumber == false)
            Expanded(
              child: ElevatedButton(
                onPressed: () async {
                  WriteNumber.writeAndReturnNumber(
                    ActionType.loadPrintedProducts,
                  );
                },
                child: FittedBox(
                  child: Text(
                    R.string.searchDataOfOtherCommandNumber,
                    style: TextStyle(
                      fontSize: StringSize.size,
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
