import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/components.dart';
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
    MenuPresenter menuPresenter = Provider.of(context, listen: false);

    return Expanded(
      child: InkWell(
        onTap: () {
          updateSelectedIndex();
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 2, right: 2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: const Color.fromARGB(255, 240, 240, 240),
            ),
          ),
          child: Row(
            children: [
              SizedBox(
                height: hasMinWidth(context) ? 100 : 70,
                width: hasMinWidth(context) ? 100 : 70,
                child: GestureDetector(
                  onTap: () {
                    showLargeImage(
                      context: context,
                      ean: null,
                      productComplement: null,
                      plu: child!.PluChild!,
                      menuPresenter: menuPresenter,
                      productName: child!.ChildName!,
                    );
                  },
                  child: ImageWidget(
                    ean: null,
                    plu: child!.PluChild!,
                    height: hasMinWidth(context) ? 100 : 70,
                    width: hasMinWidth(context) ? 100 : 70,
                    isAlcoholic: false,
                  ),
                ),
              ),
              const SizedBox(width: 5),
              if (child!.ChildName != null)
                Expanded(
                  flex: 3,
                  child: Text(
                    child!.ChildName!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: getStringSize(context),
                    ),
                  ),
                ),
              Expanded(
                child: Radio<int>(
                  value: index,
                  groupValue: father.indexOfSelectedChild,
                  visualDensity: VisualDensity.compact,
                  toggleable: father.IsOptionalItem == "true",
                  onChanged: (int? value) {
                    updateSelectedIndex();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
