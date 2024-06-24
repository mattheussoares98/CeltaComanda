import 'package:get/get.dart';

import '../../ui/helpers/errors/errors.dart';
import '../../ui/pages/pages.dart';
import '../mixins/mixins.dart';
import '../../domain/usecases/usecases.dart';

class GetxCommentsPresenter extends GetxController
    with LoadingManager, UIErrorManager
    implements CommentsPresenter {
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
    }
  }

  @override
  void changeCommentIsSelected(int index) {}
}
