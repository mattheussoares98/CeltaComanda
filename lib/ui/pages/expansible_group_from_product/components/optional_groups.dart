import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

import '../../pages.dart';

class OptionalGroups extends StatefulWidget {
  final ProductsViewModel selectedProduct;
  final int selectedLeftIndex;
  const OptionalGroups({
    required this.selectedProduct,
    required this.selectedLeftIndex,
    super.key,
  });

  @override
  State<OptionalGroups> createState() => _CommentsState();
}

class _CommentsState extends State<OptionalGroups> {
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

  int getCommentsLenght(
    ExpansibleGroupFromProductPresenter expansibleGroupFromProductPresenter,
    InsertProductPresenter insertProductPresenter,
  ) {
    final lenght = expansibleGroupFromProductPresenter.loadedComments
        .where((e) =>
            e.ProductInternalCodeOnErp.toInt() ==
            getInternalCodeOnErp(insertProductPresenter))
        .length;

    return lenght;
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
      itemCount: getCommentsLenght(
          expansibleGroupFromProductPresenter, insertProductPresenter),
      itemBuilder: (context, index) {
        final comments = expansibleGroupFromProductPresenter.loadedComments
            .where((e) =>
                int.parse(e.ProductInternalCodeOnErp) ==
                getInternalCodeOnErp(insertProductPresenter))
            .toList();

        final comment = comments[index];

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
                      .changeCommentIsSelected(comment);
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
                        comment.GroupName,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Checkbox(
                      semanticLabel: comment.GroupName,
                      value: comment.selected,
                      onChanged: (value) {
                        setState(() {
                          expansibleGroupFromProductPresenter
                              .changeCommentIsSelected(comment);
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
