import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

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
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              contentPadding: const EdgeInsets.all(8),
              title: const Text(
                "Deseja confirmar os produtos e alterar o comentário?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
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
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        "Cancelar",
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    ),
                    TextButton(
                      child: const Text("Confirmar"),
                      onPressed: () async {
                        if (commentsController.text.isNotEmpty) {
                          saleRequestTempPresenter
                              .updateLocalSaleRequestComment(
                            commentsController.text,
                          );
                        }

                        Navigator.of(context).pop();

                        await saleRequestTempPresenter.finishSaleRequest(
                          saleRequestTempEntity: saleRequestTempPresenter
                              .saleRequestTemp!
                              .toEntity(),
                          expansibleGroupsPresenter: expansibleGroupsPresenter,
                          printedProductsPresenter: printedProductsPresenter,
                          saleRequestTempPresenter: saleRequestTempPresenter,
                          homePresenter: homePresenter,
                        );
                      },
                    ),
                  ],
                ),
              ],
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
