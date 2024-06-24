import 'package:flutter/material.dart';

import '../../../ui/pages/pages.dart';
import '../../helpers/helpers.dart';

abstract class CommentsPresenter implements Listenable {
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;
  List<CommentViewModel> get loadedComments;
  bool get hasSelectedComments;

  Future<void> addComment(CommentViewModel newComment);
  Future<void> loadComments();
  Future<void> changeCommentIsSelected(int index);
  void unselectAllComments();
}
