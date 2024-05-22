import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

import '../../../../ui/components/components.dart';
import '../../pages.dart';

class SaveSaleRequestButton extends StatelessWidget {
  const SaveSaleRequestButton({super.key});

  @override
  Widget build(BuildContext context) {
    SaleRequestTempPresenter saleRequestTempPresenter =
        Provider.of(context, listen: false);
    ExpansibleGroupsPresenter expansibleGroupsPresenter =
        Provider.of(context, listen: false);
    PrintedProductsPresenter printedProductsPresenter =
        Provider.of(context, listen: false);
    HomePresenter homePresenter = Provider.of(context, listen: false);

    TextEditingController commentsController = TextEditingController();
    FocusNode commentsFocusNode = FocusNode();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 40),
        ),
        onPressed: () async {
          if (printedProductsPresenter.printedProducts?.Comments != null) {
            commentsController.text =
                printedProductsPresenter.printedProducts!.Comments!;
          }
          notificationDialog(
            context: context,
            titleMessage: "Deseja confirmar os produtos?",
            content: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 15),
                  const Text(
                      "Esse comentário abaixo é o da comanda inteira, não é o comentário de um produto específico. Você não é obrigado a colocar um comentário"),
                  const SizedBox(height: 15),
                  ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxHeight: 100,
                    ),
                    child: TextFormField(
                      focusNode: commentsFocusNode,
                      controller: commentsController,
                      maxLines: null,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(3, 10, 3, 3),
                        label: Text("Inserir comentário na comanda"),
                        hintText: "Comentário",
                      ),
                    ),
                  ),
                ],
              ),
            ),
            onPress: () async {
              if (commentsController.text.isNotEmpty) {
                saleRequestTempPresenter.updateLocalSaleRequestComment(
                  commentsController.text,
                );
              }

              await saleRequestTempPresenter.finishSaleRequest(
                saleRequestTempEntity:
                    saleRequestTempPresenter.saleRequestTemp!.toEntity(),
                expansibleGroupsPresenter: expansibleGroupsPresenter,
                printedProductsPresenter: printedProductsPresenter,
                saleRequestTempPresenter: saleRequestTempPresenter,
                homePresenter: homePresenter,
              );
            },
          );
        },
        child: const Text(
          'Salvar/imprimir produtos',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
