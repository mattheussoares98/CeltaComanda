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
      physics: const NeverScrollableScrollPhysics(),
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
          padding: const EdgeInsets.only(bottom: 8),
          child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  offset: Offset(2, 2),
                  color: Color.fromARGB(255, 209, 208, 208),
                  blurRadius: 8,
                ),
                BoxShadow(
                  offset: Offset(-2, -2),
                  color: Color.fromARGB(255, 209, 208, 208),
                  blurRadius: 8,
                ),
              ],
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
                padding: hasMinWidth(context)
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
