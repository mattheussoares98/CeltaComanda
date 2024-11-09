import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../pages.dart';

class SelectCommandDropDown extends StatefulWidget {
  const SelectCommandDropDown({super.key});

  @override
  State<SelectCommandDropDown> createState() => _SelectCommandDropDownState();
}

class _SelectCommandDropDownState extends State<SelectCommandDropDown> {
  @override
  Widget build(BuildContext context) {
    HomePresenter homePresenter = Provider.of(context, listen: false);
    PrintedProductsPresenter printedProductsPresenter =
        Provider.of(context, listen: false);

    return DropdownButton(
      isExpanded: true,
      alignment: Alignment.center,
      hint: Text(homePresenter.commandNumber.toString()),
      items: List<int>.generate(
        100,
        (int index) => index++,
        growable: true,
      )
          .map(
            (e) => DropdownMenuItem(
              value: e + 1,
              onTap: () async {},
              child: Center(
                child: Text(
                  (e + 1).toString(),
                ),
              ),
            ),
          )
          .toList(),
      onChanged: (value) async {
        homePresenter.updateCommandNumber(value!.toString());
        await printedProductsPresenter.loadPrinted(homePresenter);
        setState(() {});
      },
    );
  }
}
