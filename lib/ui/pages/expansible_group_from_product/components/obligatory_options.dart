import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

import '../../pages.dart';

class ObligatoryOptions extends StatefulWidget {
  final ProductsViewModel selectedProduct;
  final int selectedLeftIndex;
  const ObligatoryOptions({
    required this.selectedProduct,
    required this.selectedLeftIndex,
    super.key,
  });

  @override
  State<ObligatoryOptions> createState() => _CommentsState();
}

class _CommentsState extends State<ObligatoryOptions> {
  final iconButtonFocusNode = FocusNode();

  int getInternalCodeOnErp() {
    if (widget.selectedProduct.childsComposition == null) {
      return widget.selectedProduct.InternalCodeOnERP!.toInt();
    } else {
      return widget.selectedProduct.childsComposition![widget.selectedLeftIndex]
          .InternalCodeOnERPCodeChild!
          .toInt();
    }
  }

  int getObligatoryOptionsLenght(
    ExpansibleGroupFromProductPresenter expansibleGroupFromProductPresenter,
  ) {
    final lenght = expansibleGroupFromProductPresenter.loadedObligatoryOptions
        .where(
            (e) => e.ProductInternalCodeOnErp.toInt() == getInternalCodeOnErp())
        .length;

    return lenght;
  }

  @override
  Widget build(BuildContext context) {
    ExpansibleGroupFromProductPresenter expansibleGroupFromProductPresenter =
        Provider.of(context);

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount:
          getObligatoryOptionsLenght(expansibleGroupFromProductPresenter),
      itemBuilder: (context, index) {
        final obligatoryOptions = expansibleGroupFromProductPresenter
            .loadedObligatoryOptions
            .where((e) =>
                int.parse(e.ProductInternalCodeOnErp) == getInternalCodeOnErp())
            .toList();

        final obligatoryOption = obligatoryOptions[index];

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
                  debugPrint(
                    "Criar opção para alterar o índice da opção obrigatória selecionada e remover a opção selecionada ao sair da página",
                  );
                  // expansibleGroupFromProductPresenter
                  //     .changeCommentIsSelected(comment);
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
                          debugPrint(
                            "Criar opção para alterar o índice da opção obrigatória selecionada e remover a opção selecionada ao sair da página",
                          );
                          // expansibleGroupFromProductPresenter
                          //     .changeCommentIsSelected(comment);
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
