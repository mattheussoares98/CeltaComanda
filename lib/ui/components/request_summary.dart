import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../presentation/presenters/presenters.dart';

class RequestSummary extends StatefulWidget {
  final String totalLiquid;
  final String? comments;
  final bool canUpdateComment;
  const RequestSummary({
    required this.totalLiquid,
    required this.comments,
    required this.canUpdateComment,
    super.key,
  });

  @override
  State<RequestSummary> createState() => _RequestSummaryState();
}

class _RequestSummaryState extends State<RequestSummary> {
  TextEditingController commentsController = TextEditingController();
  FocusNode commentsFocusNode = FocusNode();
  bool showTextFormField = false;

  void onTapCommentIcon() {
    setState(() {
      showTextFormField = !showTextFormField;
    });

    if (widget.comments != null) {
      setState(() {
        commentsController.text = widget.comments!;
      });
    }

    Future.delayed(const Duration(milliseconds: 300), () {
      FocusScope.of(context).requestFocus(commentsFocusNode);
      commentsController.selection = TextSelection(
          baseOffset: 0, extentOffset: commentsController.text.length);
    });
  }

  @override
  Widget build(BuildContext context) {
    GetxPrintedProductsPresenter printedProductsPresenter =
        Provider.of(context);
    GetxHomePresenter homePresenter = Provider.of(context);
    GetxSaleRequestTempPresenter saleRequestTempPresenter =
        Provider.of(context);
    GetxExpansibleGroupsPresenter expansibleGroupsPresenter =
        Provider.of(context);
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
              ),
              Text("${widget.totalLiquid} R\$"),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              if (widget.canUpdateComment)
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        onTapCommentIcon();
                      },
                      child: Icon(
                        color: Theme.of(context).colorScheme.primary,
                        widget.comments == null
                            ? Icons.add_comment_rounded
                            : Icons.edit,
                        size: 25,
                      ),
                    ),
                    const SizedBox(width: 10),
                  ],
                ),
              if (widget.comments != null)
                Expanded(child: Text("Comentário: ${widget.comments}")),
            ],
          ),
          if (showTextFormField)
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    focusNode: commentsFocusNode,
                    controller: commentsController,
                    maxLines: null,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value?.isEmpty == true) {
                        return "Digite o comentário";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    await printedProductsPresenter.updateComment(
                      printedProductsPresenter: printedProductsPresenter,
                      newComment: commentsController.text,
                      homePresenter: homePresenter,
                      saleRequestTempPresenter: saleRequestTempPresenter,
                      expansibleGroupsPresenter: expansibleGroupsPresenter,
                    );
                  },
                  child: const Text(
                    "Alterar\ncomentário",
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
