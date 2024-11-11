import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../helpers/helpers.dart';
import '../../pages.dart';

class SelectCommandDropDown extends StatelessWidget {
  final int? selectedCommandInDropDown;
  final void Function(int? value) updateSelectedCommandInDropDown;
  const SelectCommandDropDown({
    required this.selectedCommandInDropDown,
    required this.updateSelectedCommandInDropDown,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    CancelProductsPresenter cancelProductsPresenter =
        Provider.of(context, listen: false);

    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: DropdownButton(
              isExpanded: true,
              alignment: Alignment.center,
              hint: Text(selectedCommandInDropDown == null
                  ? R.string.msgSelectCommand
                  : "${R.string.table} $selectedCommandInDropDown"),
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: getStringSize(context),
                  color: Colors.black),
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
                updateSelectedCommandInDropDown(value);
                await cancelProductsPresenter.loadProducts(value!);
              },
            ),
          ),
        ),
        IconButton(
          onPressed: selectedCommandInDropDown == null
              ? null
              : () async {
                  updateSelectedCommandInDropDown(selectedCommandInDropDown);
                  await cancelProductsPresenter
                      .loadProducts(selectedCommandInDropDown!);
                },
          icon: const Icon(Icons.refresh),
        ),
      ],
    );
  }
}
