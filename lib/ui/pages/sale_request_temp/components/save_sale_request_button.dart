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

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        minimumSize: const Size(double.infinity, 40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(
            color: Color(0xFFE0E3E7),
          ),
        ),
      ),
      onPressed: () async {
        if (printedProductsPresenter.printedProducts?.Comments != null) {
          commentsController.text =
              printedProductsPresenter.printedProducts!.Comments!;
        }
        notificationDialog(
          context: context,
          titleMessage: "Deseja confirmar os produtos e alterar o comentário?",
          content: SingleChildScrollView(
            child: Column(
              children: [
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
                      label: Text("Inserir comentário"),
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
    );
  }
}
