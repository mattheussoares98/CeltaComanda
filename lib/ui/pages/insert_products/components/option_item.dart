import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../helpers/helpers.dart';
import '../../pages.dart';

class OptionItem extends StatelessWidget {
  final int atualIndex;
  final Color itemColor;
  final InsertProductsViewModel insertProductViewModel;
  final ProductCompositionViewModel? lastSelectedFather;
  const OptionItem({
    required this.atualIndex,
    required this.itemColor,
    required this.insertProductViewModel,
    required this.lastSelectedFather,
    super.key,
  });

  String getIsOptionalOrObligatory() {
    SelectedOptionType atualOption =
        insertProductViewModel.selectedOptions.entries.first.key;
    dynamic optionValue =
        insertProductViewModel.selectedOptions.entries.first.value;

    // product,

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

    // product,

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
        insertProductPresenter.updateFatherIndex(
          newIndex: atualIndex,
          expansibleGroupFromProductPresenter:
              expansibleGroupFromProductPresenter,
        );
      },
      child: Container(
        height: 42,
        color: itemColor,
        margin: const EdgeInsets.only(bottom: 1),
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: RichText(
                text: TextSpan(
                  text: getOptionItemTitle(atualOption),
                  children: lastSelectedFather == null ||
                          atualOption == SelectedOptionType.fatherComposition ||
                          atualOption == SelectedOptionType.quantity
                      ? null
                      : <TextSpan>[
                          TextSpan(
                            text: " (${R.string.comment.toUpperCase()})",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.yellow,
                            ),
                          ),
                        ],
                ),
              ),
            ),
            FittedBox(
              child: Text(
                getIsOptionalOrObligatory(),
                textAlign: TextAlign.end,
                style: TextStyle(
                  color: Colors.yellow,
                  fontSize: getStringSize(context) * 0.7,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
