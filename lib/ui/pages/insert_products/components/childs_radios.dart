import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../ui/helpers/helpers.dart';
import '../../pages.dart';

class ChildsRadios extends StatelessWidget {
  final ProductsViewModel selectedProduct;
  final ProductCompositionViewModel selectedFather;
  final Function() callSetState;

  ChildsRadios({
    required this.selectedProduct,
    required this.selectedFather,
    required this.callSetState,
    super.key,
  });

  final Map<int, bool> _alreadyUpdated = {};

  final Map<int, String> daysOfWeek = {
    1: 'Monday',
    2: 'Tuesday',
    3: 'Wednesday',
    4: 'Thursday',
    5: 'Friday',
    6: 'Saturday',
    7: 'Sunday',
  };

  String getDayOfWeek() {
    DateTime now = DateTime.now();
    String dayOfWeek = daysOfWeek[now.weekday]!;

    return dayOfWeek;
  }

  bool isEnabledToday(ProductCompositionViewModel child) {
    final dayOfWeek = getDayOfWeek();

    if (child.Schedule == null) {
      return true;
    } else if (dayOfWeek == daysOfWeek[1]) {
      return child.Schedule!.AllowMonday == true;
    } else if (dayOfWeek == daysOfWeek[2]) {
      return child.Schedule!.AllowTuesday == true;
    } else if (dayOfWeek == daysOfWeek[3]) {
      return child.Schedule!.AllowWednesday == true;
    } else if (dayOfWeek == daysOfWeek[4]) {
      return child.Schedule!.AllowThursday == true;
    } else if (dayOfWeek == daysOfWeek[5]) {
      return child.Schedule!.AllowFriday == true;
    } else if (dayOfWeek == daysOfWeek[6]) {
      return child.Schedule!.AllowSaturday == true;
    } else if (dayOfWeek == daysOfWeek[7]) {
      return child.Schedule!.AllowSunday == true;
    } else {
      return false;
    }
  }

  int getItemCount() {
    if (selectedFather.childs == null ||
        selectedFather.childs!.isEmpty == true) {
      return 1;
    } else {
      return selectedFather.childs!.length;
    }
  }

  bool haveAnActiveChild() {
    if (selectedFather.childs == null) {
      return true;
    }

    for (var child in selectedFather.childs!) {
      if (isEnabledToday(child)) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    InsertProductPresenter insertProductsPresenter =
        Provider.of(context, listen: false);
    ExpansibleGroupFromProductPresenter expansibleGroupFromProductPresenter =
        Provider.of(context, listen: false);

    if (selectedFather.IsPromoCombox == "true" &&
        (selectedFather.childs == null || selectedFather.childs!.isEmpty)) {
      return Text(
        "${R.string.msgMissingChilds} (${selectedFather.ChildName})",
        style: TextStyle(
          color: Colors.red,
          fontSize: StringSize.size,
          fontWeight: FontWeight.bold,
        ),
      );
    }

    if (!haveAnActiveChild()) {
      Future.delayed(Duration.zero, () {
        insertProductsPresenter.updateCanAdvanceIndex(
          expansibleGroupFromProductPresenter:
              expansibleGroupFromProductPresenter,
          value: false,
        );
      });
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            R.string.msgAllChildsAreDisabled,
            style: TextStyle(
              color: Colors.red,
              fontSize: StringSize.size,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }
    return ListView.builder(
      shrinkWrap: true,
      itemCount: getItemCount(),
      itemBuilder: (context, i) {
        _alreadyUpdated.putIfAbsent(i, () => false);

        ProductCompositionViewModel child;
        bool hasChilds = selectedFather.childs?.isNotEmpty == true;

        if (hasChilds) {
          child = selectedFather.childs![i];
          if (!isEnabledToday(child)) {
            return const SizedBox();
          }
        } else {
          child = selectedFather;
          Future.delayed(Duration.zero, () {
            if (child.IsOptionalItem == "false" &&
                _alreadyUpdated[i] == false) {
              _alreadyUpdated[i] = true;
              _updateSelectedIndex(
                expansibleGroupFromProductPresenter:
                    expansibleGroupFromProductPresenter,
                insertProductsPresenter: insertProductsPresenter,
                value: i,
                selectedFather: selectedFather,
                selectedProduct: selectedProduct,
              );
            }
          });
        }

        double? incrementValue;

        if (selectedFather.IncrementValue!.toDouble() > 0) {
          incrementValue = selectedFather.IncrementValue!.toDouble();
        } else if (child.IncrementValue!.toDouble() > 0) {
          incrementValue = child.IncrementValue!.toDouble();
        }

        return InkWell(
          onTap: () {
            _updateSelectedIndex(
              expansibleGroupFromProductPresenter:
                  expansibleGroupFromProductPresenter,
              insertProductsPresenter: insertProductsPresenter,
              value: i,
              selectedFather: selectedFather,
              selectedProduct: selectedProduct,
            );
            callSetState();
          },
          child: RadioGroup(
            groupValue: selectedFather.indexOfSelectedChild,
            child: Row(
              children: [
                Radio(value: i),
                Expanded(
                  child: Text(
                    child.ChildName ?? "",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                      fontSize: StringSize.size,
                    ),
                  ),
                ),
                if (incrementValue != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Text(
                      "+ ${incrementValue.toString().toBrazilianNumber().addBrazilianCoin()}",
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        fontSize: StringSize.size,
                        fontWeight: FontWeight.w300,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
              ],
            ),
            onChanged: (int? value) {
              _updateSelectedIndex(
                expansibleGroupFromProductPresenter:
                    expansibleGroupFromProductPresenter,
                insertProductsPresenter: insertProductsPresenter,
                value: value,
                selectedFather: selectedFather,
                selectedProduct: selectedProduct,
              );
              callSetState();
            },
          ),
        );
      },
    );
  }
}

void _updateSelectedIndex({
  required InsertProductPresenter insertProductsPresenter,
  required int? value,
  required ProductCompositionViewModel selectedFather,
  required ProductsViewModel selectedProduct,
  required ExpansibleGroupFromProductPresenter
      expansibleGroupFromProductPresenter,
}) {
  insertProductsPresenter.updateSelectedIndexOfProduct(
    father: selectedFather,
    index: value,
    expansibleGroupFromProductPresenter: expansibleGroupFromProductPresenter,
  );

  insertProductsPresenter.updateTotalLiquid(
    selectedProduct,
  );
}
