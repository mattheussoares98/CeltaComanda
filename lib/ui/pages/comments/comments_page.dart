import 'dart:async';

import 'package:clean_celta_mobile/ui/pages/pages.dart';
import 'package:provider/provider.dart';

import '../../mixins/mixins.dart';

import 'package:flutter/material.dart';

class CommentsPage extends StatefulWidget {
  const CommentsPage({super.key});

  @override
  State<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage>
    with KeyboardManager, LoadingManager, UIErrorManager {
  final commentsController = TextEditingController();

  bool _isLoaded = false;
  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (!_isLoaded) {
      _isLoaded = true;
      Future.delayed(Duration.zero, () async {
        CommentsPresenter commentsPresenter =
            Provider.of(context, listen: false);
        await commentsPresenter.loadComments();
      });
    }
  }

  StreamSubscription? loadingSubscription;
  StreamSubscription? mainErrorSubscription;

  @override
  void dispose() {
    super.dispose();
    loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    CommentsPresenter commentsPresenter = Provider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const FittedBox(child: Text("Comentários do produto")),
      ),
      body: Builder(
        builder: (context) {
          loadingSubscription =
              handleLoading(context, commentsPresenter.isLoadingStream);
          mainErrorSubscription =
              handleMainError(context, commentsPresenter.mainErrorStream);

          return SingleChildScrollView(
            child: Builder(
              builder: (context) {
                loadingSubscription?.cancel();
                mainErrorSubscription?.cancel();

                loadingSubscription =
                    handleLoading(context, commentsPresenter.isLoadingStream);
                mainErrorSubscription =
                    handleMainError(context, commentsPresenter.mainErrorStream);

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    children: [
                      Form(
                        child: TextFormField(
                          controller: commentsController,
                          decoration: const InputDecoration(
                            hintText: "Comentário",
                          ),
                          onFieldSubmitted: (value) async {
                            await commentsPresenter.addComment(
                              CommentViewModel(
                                comment: commentsController.text,
                                selected: false,
                              ),
                            );

                            commentsController.clear();
                          },
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (commentsPresenter.loadedComments.isNotEmpty)
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: commentsPresenter.loadedComments.length,
                          itemBuilder: (context, index) {
                            final comment =
                                commentsPresenter.loadedComments[index];
                            bool selected = false;

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Material(
                                elevation: 5,
                                child: ListTile(
                                  onTap: () {
                                    setState(() {
                                      comment.selected = !comment.selected;
                                    });
                                  },
                                  selected: selected,
                                  leading: Text(
                                    comment.comment,
                                    style: const TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                  trailing: Checkbox(
                                    semanticLabel: comment.comment,
                                    value: comment.selected,
                                    onChanged: (value) {
                                      setState(() {
                                        comment.selected = value!;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
