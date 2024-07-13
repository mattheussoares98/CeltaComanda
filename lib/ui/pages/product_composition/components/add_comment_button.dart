import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../helpers/helpers.dart';
import '../../pages.dart';

class AddCommentButton extends StatelessWidget {
  final ProductCompositionViewModel father;
  final void Function() callSetState;

  const AddCommentButton({
    required this.father,
    required this.callSetState,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    ProductCompositionPresenter productCompositionPresenter =
        Provider.of(context, listen: false);
    CommentsPresenter commentsPresenter = Provider.of(context, listen: false);

    return Flexible(
      child: GestureDetector(
        onTap: () async {
          commentsPresenter.updateSelectedComments(father.commentFather);
          await showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              builder: (context) {
                return ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.9,
                    child: CommentsPage(
                      selectedProductName: father.ChildName!,
                    ),
                  ),
                );
              });

          productCompositionPresenter.updateComment(
            commentsPresenter: commentsPresenter,
            father: father,
          );
          callSetState();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(
              father.commentFather == null
                  ? Icons.add_comment_rounded
                  : Icons.edit,
              color: Colors.grey,
            ),
            const SizedBox(width: 5),
            Text(
              "Comentários",
              style: TextStyle(
                fontSize: getStringSize(context),
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
