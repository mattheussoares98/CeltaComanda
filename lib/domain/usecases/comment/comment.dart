import '../../../ui/pages/pages.dart';

abstract class Comments {
  Future<void> add(List<CommentViewModel> comments);
  Future<List<CommentViewModel>?> load();
}
