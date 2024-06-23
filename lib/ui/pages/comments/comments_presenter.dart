import '../../helpers/helpers.dart';

import 'package:flutter/material.dart';

abstract class CommentsPresenter implements Listenable {
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isFormValidStream;
  Stream<bool> get isLoadingStream;

  Future<void> addComment(String newComment);
  Future<void> loadComments();
}
