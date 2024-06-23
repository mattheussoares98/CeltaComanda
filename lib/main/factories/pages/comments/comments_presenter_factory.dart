import '../../../../main/factories/factories.dart';
import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/pages/pages.dart';

CommentsPresenter makeCommentsPresenter() => GetxCommentsPresenter(
      comments: makeLocalComments(),
    );
