// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/domain/usecases/usecases.dart';
import 'package:clean_celta_mobile/ui/pages/pages.dart';

import 'package:mocktail/mocktail.dart';

class CommentsSpy extends Mock implements Comments {
  When mockAddCommentsCall() => when(() => this.add(any()));
  void mockAddComments() =>
      this.mockAddCommentsCall().thenAnswer((_) async => _);
  void mockAddCommentsError() =>
      this.mockAddCommentsCall().thenThrow(DomainError.unexpected);

  When mockLoadCommentsCall() => when(() => this.load());
  void mockLoadComments(List<CommentViewModel> comments) =>
      this.mockLoadCommentsCall().thenAnswer((_) async => comments);
  void mockLoadCommentsError() =>
      this.mockLoadCommentsCall().thenThrow(DomainError.unexpected);
}
