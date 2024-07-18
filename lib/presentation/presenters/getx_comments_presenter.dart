import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';
import '../../domain/usecases/usecases.dart';

class GetxCommentsPresenter with ChangeNotifier implements CommentsPresenter {
  final LoadExpansibleGroupsFromProductsComplete
      loadExpansibleGroupsFromProductsComplete;

  GetxCommentsPresenter({
    required this.loadExpansibleGroupsFromProductsComplete,
  });

  List<CommentViewModel> _loadedComments = [];
  @override
  List<CommentViewModel> get loadedComments => _loadedComments;

  @override
  Future<void> loadComments(List<ProductsViewModel> loadedProducts) async {
    isLoading = true;
    mainError = null;

    try {
      final allInternalCodes = loadedProducts
          .map(
            (e) => e.InternalCodeOnERP!.toInt(),
          )
          .toList();

      final optionalGroups =
          await loadExpansibleGroupsFromProductsComplete.load(allInternalCodes);

      _loadedComments = optionalGroups
          .map((e) =>
              CommentViewModel.fromExpansibleGroupsFromProductsCompleteEntity(
                e,
              ))
          .toList();
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
        .map((element) => element.GroupName)
        .join("\n");

    if (concatenateSelectedComments.isEmpty) {
      return null;
    } else {
      return concatenateSelectedComments;
    }
  }

  @override
  void updateSelectedComments(String? comments) {
    for (var loadedComment in loadedComments) {
      loadedComment.selected =
          comments != null && comments.contains(loadedComment.GroupName);
    }
    notifyListeners();
  }
}
