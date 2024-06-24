import 'package:flutter/material.dart';

import '../../../ui/pages/pages.dart';
import '../../helpers/helpers.dart';

abstract class CommentsPresenter implements Listenable {
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;
  Stream<List<CommentViewModel>> get localCommentsStream;

  Future<void> addComment(CommentViewModel newComment);
  Future<void> loadComments();
  void changeCommentIsSelected(int index);
}
