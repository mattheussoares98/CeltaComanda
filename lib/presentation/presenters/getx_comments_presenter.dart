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
  Future<void> addComment(String newComment) async {
    isLoading = true;
    mainError = null;

    try {
      if (_usedComments.contains(newComment)) {
        return;
      }

      _usedComments.add(newComment);
      await comments.add(_usedComments);
    } catch (e) {
      mainError = UIError.unexpected;
    } finally {
      isLoading = false;
    }
  }

  List<String> _usedComments = [];
  @override
  List<String> get localComments => _usedComments;

  @override
  Future<void> loadComments() async {
    isLoading = true;
    mainError = null;

    try {
      final localComments = await comments.load();
      if (localComments != null) {
        _usedComments = localComments;
      }
    } catch (e) {
      mainError = UIError.unexpected;
    } finally {
      isLoading = false;
    }
  }
}
