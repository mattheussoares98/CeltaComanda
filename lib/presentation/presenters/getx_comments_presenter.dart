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
      if (_localComments.value.contains(newComment)) {
        return;
      }

      _localComments.subject.add([newComment]);
      _localComments.value = [newComment];
      await comments.add(_localComments.value);
    } catch (e) {
      mainError = UIError.unexpected;
    } finally {
      isLoading = false;
    }
  }

  final _localComments = Rx<List<CommentViewModel>>([]);
  @override
  Stream<List<CommentViewModel>> get localCommentsStream => _localComments.stream;

  @override
  Future<void> loadComments() async {
    isLoading = true;
    mainError = null;

    try {
      final localComments = await comments.load();
      if (localComments != null) {
        _localComments.value = localComments;
      }
    } catch (e) {
      mainError = UIError.unexpected;
      _localComments.value = [];
    } finally {
      isLoading = false;
    }
  }

  @override
  void changeCommentIsSelected(int index) {}
}
