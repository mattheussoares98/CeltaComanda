import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

import '../../../components/components.dart';
import '../../pages.dart';

class CommentsList extends StatefulWidget {
  const CommentsList({super.key});

  @override
  State<CommentsList> createState() => _CommentsState();
}

class _CommentsState extends State<CommentsList> {
  @override
  Widget build(BuildContext context) {
    CommentsPresenter commentsPresenter = Provider.of(context, listen: false);

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: commentsPresenter.loadedComments.length,
      itemBuilder: (context, index) {
        final comment = commentsPresenter.loadedComments[index];

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
                  commentsPresenter.changeCommentIsSelected(index);
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        comment.comment,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Checkbox(
                      semanticLabel: comment.comment,
                      value: comment.selected,
                      onChanged: (value) {
                        setState(() {
                          commentsPresenter.changeCommentIsSelected(index);
                        });
                      },
                    ),
                    IconButton(
                      onPressed: () async {
                        notificationDialog(
                            context: context,
                            titleMessage: "Excluir comentário?",
                            content: null,
                            onPress: () async {
                              await commentsPresenter.deleteComment(index);
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
