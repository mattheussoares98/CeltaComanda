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
      _loadedComments.sort((a, b) => a.comment.compareTo(b.comment));
      await comments.add(_loadedComments);
      updateHasSelectedComments();
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
        _loadedComments.sort((a, b) => a.comment.compareTo(b.comment));
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
  Future<void> changeCommentIsSelected(int index) async {
    _loadedComments[index].selected = !_loadedComments[index].selected;
    updateHasSelectedComments();
  }

  final _isLoading = false.obs;
  @override
  Stream<bool> get isLoadingStream => _isLoading.stream;
  set isLoading(bool value) => _isLoading.value = value;
  final _mainError = Rx<UIError?>(null);

  @override
  Stream<UIError?> get mainErrorStream => _mainError.stream;
  set mainError(UIError? value) => _mainError.value = value;

  @override
  void unselectAllComments() {
    for (var comment in loadedComments) {
      comment.selected = false;
    }
    updateHasSelectedComments();
  }

  bool _hasSelectedComments = false;
  @override
  bool get hasSelectedComments => _hasSelectedComments;

  @override
  void updateHasSelectedComments() {
    _hasSelectedComments = false;
    for (var comment in _loadedComments) {
      if (comment.selected) {
        _hasSelectedComments = true;
        break;
      }
    }
    notifyListeners();
  }

  @override
  String? getConcatenateSelectedComments() {
    final concatenateSelectedComments = _loadedComments
        .where((comment) => comment.selected)
        .map((element) => element.comment)
        .join("\n");

    if (concatenateSelectedComments.isEmpty) {
      return null;
    } else {
      return concatenateSelectedComments;
    }
  }

  @override
  void updateSelectedComments(String comments) {
    for (var loadedComment in loadedComments) {
      loadedComment.selected = comments.contains(loadedComment.comment);
    }
    notifyListeners();
  }
}
