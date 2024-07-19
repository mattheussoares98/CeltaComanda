import 'package:flutter/material.dart';

import '../../../ui/pages/pages.dart';
import '../../helpers/helpers.dart';

abstract class CommentsPresenter implements Listenable {
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;
  List<CommentViewModel> get loadedComments;
  bool get hasSelectedComments;

  Future<void> loadComments(List<int> allInternalCodesOnErp);
  Future<void> changeCommentIsSelected(CommentViewModel comment);
  void unselectAllComments();
  void updateHasSelectedComments();
  String? getConcatenateSelectedComments();
  void updateSelectedComments({
    required String? comments,
    required int internalCodeOnERP,
  });
}
