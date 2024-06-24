import '../../helpers/helpers.dart';

import 'package:flutter/material.dart';

abstract class CommentsPresenter implements Listenable {
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;
  List<String> get localComments;

  Future<void> addComment(String newComment);
  Future<void> loadComments();
}
