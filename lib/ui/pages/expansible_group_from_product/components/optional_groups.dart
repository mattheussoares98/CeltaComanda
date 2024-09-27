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
          padding: const EdgeInsets.all(3),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              color: comment.selected
                  ? Theme.of(context).primaryColorLight.withAlpha(60)
                  : Theme.of(context).primaryColorLight.withAlpha(15),
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
