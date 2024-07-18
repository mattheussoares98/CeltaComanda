import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

import '../../../components/components.dart';
import '../../pages.dart';

class CommentsList extends StatefulWidget {
  final int productInternalCodeOnERP;
  final String selectedProductName;
  const CommentsList({
    required this.productInternalCodeOnERP,
    required this.selectedProductName,
    super.key,
  });

  @override
  State<CommentsList> createState() => _CommentsState();
}

class _CommentsState extends State<CommentsList> {
  final iconButtonFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    CommentsPresenter commentsPresenter = Provider.of(context);

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: commentsPresenter.loadedComments
          .where((e) =>
              int.parse(e.ProductInternalCodeOnErp) ==
              widget.productInternalCodeOnERP)
          .length,
      itemBuilder: (context, index) {
        final comments = commentsPresenter.loadedComments
            .where((e) =>
                int.parse(e.ProductInternalCodeOnErp) ==
                widget.productInternalCodeOnERP)
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
                  commentsPresenter.changeCommentIsSelected(comment);
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
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
                          commentsPresenter.changeCommentIsSelected(comment);
                        });
                      },
                    ),
                    IconButton(
                      focusNode: iconButtonFocusNode,
                      onPressed: () async {
                        notificationDialog(
                            context: context,
                            titleMessage: "Excluir comentário?",
                            content: null,
                            onCancelPress: () async {
                              iconButtonFocusNode.requestFocus();
                            },
                            onPress: () async {
                              iconButtonFocusNode.requestFocus();
                              setState(() {});
                            });
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
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
