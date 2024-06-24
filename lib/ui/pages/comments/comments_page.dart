import 'dart:async';

import 'package:clean_celta_mobile/ui/pages/pages.dart';

import '../../mixins/mixins.dart';

import 'package:flutter/material.dart';

class CommentsPage extends StatefulWidget {
  final CommentsPresenter presenter;

  const CommentsPage(this.presenter, {super.key});

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
        await widget.presenter.loadComments();
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
    return Scaffold(
      appBar: AppBar(
        title: const FittedBox(child: Text("Comentários do produto")),
      ),
      body: Builder(
        builder: (context) {
          loadingSubscription =
              handleLoading(context, widget.presenter.isLoadingStream);
          mainErrorSubscription =
              handleMainError(context, widget.presenter.mainErrorStream);

          return SingleChildScrollView(
            child: Builder(
              builder: (context) {
                loadingSubscription?.cancel();
                mainErrorSubscription?.cancel();

                loadingSubscription =
                    handleLoading(context, widget.presenter.isLoadingStream);
                mainErrorSubscription =
                    handleMainError(context, widget.presenter.mainErrorStream);

                return StreamBuilder<List<CommentViewModel>>(
                    stream: widget.presenter.localCommentsStream,
                    builder: (context, snapshot) {
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
                                  await widget.presenter.addComment(
                                    CommentViewModel(
                                      comment: commentsController.text,
                                      selected: false,
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 8),
                            if (snapshot.hasData && snapshot.data != null)
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context, index) {
                                  final comment = snapshot.data![index];
                                  bool selected = false;

                                  return Material(
                                    elevation: 5,
                                    child: ListTile(
                                      onTap: () {
                                        setState(() {
                                          comment.selected = !comment.selected;
                                        });
                                      },
                                      selected: selected,
                                      leading: Text(comment.comment),
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
                                  );
                                },
                              ),
                          ],
                        ),
                      );
                    });
              },
            ),
          );
        },
      ),
    );
  }
}
