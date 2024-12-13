import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../helpers/helpers.dart';
import '../../pages.dart';

class OptionItem extends StatelessWidget {
  final int optionIndex;
  final int insertProductIndex;
  final InsertProductsViewModel insertProductViewModel;
  final ProductCompositionViewModel? lastSelectedFather;
  final double itemExtent;
  const OptionItem({
    required this.optionIndex,
    required this.insertProductIndex,
    required this.insertProductViewModel,
    required this.lastSelectedFather,
    required this.itemExtent,
    super.key,
  });

  String getIsOptionalOrObligatory() {
    SelectedOptionType atualOption =
        insertProductViewModel.selectedOptions.entries.first.key;
    dynamic optionValue =
        insertProductViewModel.selectedOptions.entries.first.value;

    if (atualOption == SelectedOptionType.obligatoryExpansibleGroup) {
      return R.string.obligatory;
    } else if (atualOption == SelectedOptionType.quantity) {
      return R.string.obligatory;
    } else if (atualOption == SelectedOptionType.optionalExpansibleGroup) {
      return R.string.optional;
    } else if (atualOption == SelectedOptionType.fatherComposition) {
      final ProductCompositionViewModel productCompositionViewModel =
          optionValue as ProductCompositionViewModel;
      if (productCompositionViewModel.IsOptionalItem == "true") {
        return R.string.optional;
      } else {
        return R.string.obligatory;
      }
    }
    return R.string.optional;
  }

  String getOptionItemTitle(SelectedOptionType atualOption) {
    dynamic optionValue =
        insertProductViewModel.selectedOptions.entries.first.value;

    if (atualOption == SelectedOptionType.obligatoryExpansibleGroup) {
      if (lastSelectedFather != null) {
        return lastSelectedFather!.ChildName!;
      } else {
        return R.string.comment.toUpperCase();
      }
    } else if (atualOption == SelectedOptionType.optionalExpansibleGroup) {
      if (lastSelectedFather != null) {
        return lastSelectedFather!.ChildName!;
      } else {
        return R.string.comment.toUpperCase();
      }
    } else if (atualOption == SelectedOptionType.fatherComposition) {
      return (optionValue as ProductCompositionViewModel).ChildName.toString();
    } else {
      return R.string.quantity.toUpperCase();
    }
  }

  Color getItemColor(bool canAdvanceIndex, BuildContext context) {
    if (!canAdvanceIndex && insertProductIndex == optionIndex) {
      return Theme.of(context).primaryColor;
    } else if (canAdvanceIndex && insertProductIndex == optionIndex) {
      return Theme.of(context).primaryColorDark;
    } else {
      return Theme.of(context).primaryColorLight;
    }
  }

  String getSelectedGroups(
    ExpansibleGroupFromProductPresenter expansibleGroupFromProductPresenter,
  ) {
    final keyType = insertProductViewModel.selectedOptions.keys.first;

    if (keyType == SelectedOptionType.obligatoryExpansibleGroup ||
        keyType == SelectedOptionType.optionalExpansibleGroup) {
      final groups = insertProductViewModel.selectedOptions.values.first
          as List<ExpansibleGroupFromProductViewModel>;

      String selecteds =
          groups.where((e) => e.selected).map((e) => e.GroupName).toString();

      return selecteds
          .replaceAll(RegExp(r'\('), '')
          .replaceAll(RegExp(r'\)'), '');
    } else if (keyType == SelectedOptionType.fatherComposition) {
      final product = insertProductViewModel.selectedOptions.values.first
          as ProductCompositionViewModel;

      if (product.childs != null && product.indexOfSelectedChild != null) {
        return product.childs![product.indexOfSelectedChild!].ChildName!;
      } else if (product.indexOfSelectedChild != null) {
        return product.ChildName!;
      }
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    InsertProductPresenter insertProductPresenter =
        Provider.of(context, listen: false);
    ExpansibleGroupFromProductPresenter expansibleGroupFromProductPresenter =
        Provider.of(context, listen: false);
    SelectedOptionType atualOption =
        insertProductViewModel.selectedOptions.entries.first.key;

    return InkWell(
      onTap: () {
        insertProductPresenter.updateOptionIndex(
          newIndex: optionIndex,
          expansibleGroupFromProductPresenter:
              expansibleGroupFromProductPresenter,
        );
      },
      child: StreamBuilder<bool>(
          stream: insertProductPresenter.canAdvanceIndexStream,
          builder: (context, snapshot) {
            return Container(
              height: itemExtent,
              color: getItemColor(snapshot.data == true, context),
              margin: const EdgeInsets.only(bottom: 1),
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Row(
                children: [
                  if (hasMinWidth(context))
                    StepNumber(stepNumber: optionIndex + 1),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          height: itemExtent * 0.4,
                          child: FittedBox(
                            child: RichText(
                              text: TextSpan(
                                text: getOptionItemTitle(atualOption),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: StringSize.size,
                                ),
                                children: lastSelectedFather == null ||
                                        atualOption ==
                                            SelectedOptionType
                                                .fatherComposition ||
                                        atualOption ==
                                            SelectedOptionType.quantity
                                    ? null
                                    : <TextSpan>[
                                        TextSpan(
                                          text:
                                              " (${R.string.comment.toUpperCase()})",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.yellow,
                                            fontSize: StringSize.size,
                                          ),
                                        ),
                                      ],
                              ),
                            ),
                          ),
                        ),
                        if (hasMinWidth(context))
                          SizedBox(
                            height: itemExtent * 0.55,
                            child: Text(
                              getSelectedGroups(
                                  expansibleGroupFromProductPresenter),
                              style: TextStyle(
                                color: Colors.grey[200],
                                fontSize: StringSize.size * 0.7,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        if (!hasMinWidth(context))
                          SizedBox(
                            height: itemExtent * 0.55,
                            width: double.infinity,
                            child: FittedBox(
                              child: Text(
                                getSelectedGroups(
                                    expansibleGroupFromProductPresenter),
                                style: TextStyle(
                                  color: Colors.grey[200],
                                  fontSize: StringSize.size * 0.7,
                                ),
                                maxLines: 1,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
