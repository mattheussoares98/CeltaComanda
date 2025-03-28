import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

import '../../pages.dart';

class ObligatoryGroups extends StatefulWidget {
  final ProductsViewModel selectedProduct;
  final int selectedLeftIndex;
  const ObligatoryGroups({
    required this.selectedProduct,
    required this.selectedLeftIndex,
    super.key,
  });

  @override
  State<ObligatoryGroups> createState() => _CommentsState();
}

class _CommentsState extends State<ObligatoryGroups> {
  final iconButtonFocusNode = FocusNode();

  int getInternalCodeOnErp(InsertProductPresenter insertProductPresenter) {
    ProductCompositionViewModel? lastSelectedFather =
        insertProductPresenter.getLastSelectedFather(widget.selectedLeftIndex);

    if (lastSelectedFather == null) {
      return widget.selectedProduct.InternalCodeOnERP!.toInt();
    } else {
      return lastSelectedFather.InternalCodeOnERPCodeChild!.toInt();
    }
  }

  List<ExpansibleGroupFromProductViewModel> getObligatoryOptions(
    ExpansibleGroupFromProductPresenter expansibleGroupFromProductPresenter,
    InsertProductPresenter insertProductPresenter,
  ) {
    return expansibleGroupFromProductPresenter.loadedObligatoryOptions
        .where((e) =>
            e.ProductInternalCodeOnErp.toInt() ==
            getInternalCodeOnErp(insertProductPresenter))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    ExpansibleGroupFromProductPresenter expansibleGroupFromProductPresenter =
        Provider.of(context, listen: false);
    InsertProductPresenter insertProductPresenter =
        Provider.of(context, listen: false);

    return ListView.builder(
      shrinkWrap: true,
      itemCount: getObligatoryOptions(
        expansibleGroupFromProductPresenter,
        insertProductPresenter,
      ).length,
      itemBuilder: (context, index) {
        final obligatoryOption = getObligatoryOptions(
          expansibleGroupFromProductPresenter,
          insertProductPresenter,
        )[index];

        return Padding(
          padding: const EdgeInsets.all(3),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              color: obligatoryOption.selected
                  ? Theme.of(context).primaryColorLight.withAlpha(60)
                  : Theme.of(context).primaryColorLight.withAlpha(15),
            ),
            child: InkWell(
              onTap: () {
                setState(() {
                  expansibleGroupFromProductPresenter
                      .changeObligatoryOptionIsSelected(
                    obligatoryOptionsShowing: getObligatoryOptions(
                      expansibleGroupFromProductPresenter,
                      insertProductPresenter,
                    ),
                    selectedIndex: index,
                    insertProductPresenter: insertProductPresenter,
                  );
                });
              },
              child: Padding(
                padding: ScreenSize.hasMinWidth
                    ? const EdgeInsets.all(8.0)
                    : const EdgeInsets.only(left: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        obligatoryOption.GroupName,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Checkbox(
                      semanticLabel: obligatoryOption.GroupName,
                      value: obligatoryOption.selected,
                      onChanged: (value) {
                        setState(() {
                          expansibleGroupFromProductPresenter
                              .changeObligatoryOptionIsSelected(
                            obligatoryOptionsShowing: getObligatoryOptions(
                              expansibleGroupFromProductPresenter,
                              insertProductPresenter,
                            ),
                            selectedIndex: index,
                            insertProductPresenter: insertProductPresenter,
                          );
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
