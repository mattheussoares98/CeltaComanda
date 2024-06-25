// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/ui/pages/pages.dart';
import 'package:clean_celta_mobile/ui/helpers/helpers.dart';

import 'dart:async';
import 'package:mocktail/mocktail.dart';

class CommentsPresenterSpy extends Mock implements CommentsPresenter {
  final mainErrorController = StreamController<UIError?>();
  final isLoadingController = StreamController<bool>();
  final List<CommentViewModel> loadedCommentsController = [];

  CommentsPresenterSpy() {
    when(() => this.mainErrorStream)
        .thenAnswer((_) => mainErrorController.stream);
    when(() => this.isLoadingStream)
        .thenAnswer((_) => isLoadingController.stream);
    when(() => this.loadedComments).thenAnswer((_) => loadedCommentsController);
    when(() => this.addComment(any())).thenAnswer((_) async => _);
    when(() => this.changeCommentIsSelected(any())).thenAnswer((_) async => _);
    when(() => this.loadComments()).thenAnswer((_) async => _);
  }

  void mockGetConcatenateSelectedComments(String? comment) {
    when(() => this.getConcatenateSelectedComments())
        .thenAnswer((_) => comment);
  }
}
