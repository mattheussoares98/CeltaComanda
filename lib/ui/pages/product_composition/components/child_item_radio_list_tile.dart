import 'package:flutter/material.dart';

import '../../pages.dart';

class ChildItemRadioListTile extends StatelessWidget {
  final Function() updateSelectedIndex;
  final int index;
  final ProductCompositionViewModel father;
  final ProductCompositionViewModel? child;
  const ChildItemRadioListTile({
    required this.updateSelectedIndex,
    required this.index,
    required this.father,
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        updateSelectedIndex();
      },
      child: Row(
        children: [
          const SizedBox(width: 5),
          Radio<int>(
            value: index,
            groupValue: father.indexOfSelectedChild,
            visualDensity: VisualDensity.compact,
            toggleable: father.IsOptionalItem == "true",
            onChanged: (int? value) {
              updateSelectedIndex();
            },
          ),
          if (child!.ChildName != null)
            Text(
              child!.ChildName!,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
        ],
      ),
    );
  }
}
