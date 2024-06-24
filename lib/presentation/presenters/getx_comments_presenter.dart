import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../ui/helpers/errors/errors.dart';
import '../../ui/pages/pages.dart';
import '../../domain/usecases/usecases.dart';

class GetxCommentsPresenter with ChangeNotifier implements CommentsPresenter {
  final Comments comments;

  GetxCommentsPresenter({
    required this.comments,
  });

  @override
  Future<void> addComment(CommentViewModel newComment) async {
    isLoading = true;
    mainError = null;

    try {
      if (_loadedComments.contains(newComment)) {
        return;
      }

      _loadedComments.add(newComment);
      await comments.add(_loadedComments);
    } catch (e) {
      mainError = UIError.unexpected;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  List<CommentViewModel> _loadedComments = [];
  @override
  List<CommentViewModel> get loadedComments => _loadedComments;

  @override
  Future<void> loadComments() async {
    isLoading = true;
    mainError = null;

    try {
      final localComments = await comments.load();
      if (localComments != null) {
        _loadedComments = localComments;
      }
    } catch (e) {
      mainError = UIError.unexpected;
      _loadedComments = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  @override
  void changeCommentIsSelected(int index) {}

  final _isLoading = false.obs;
  @override
  Stream<bool> get isLoadingStream => _isLoading.stream;
  set isLoading(bool value) => _isLoading.value = value;
  final _mainError = Rx<UIError?>(null);

  @override
  Stream<UIError?> get mainErrorStream => _mainError.stream;
  set mainError(UIError? value) => _mainError.value = value;
}
