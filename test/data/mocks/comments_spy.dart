// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/domain/usecases/usecases.dart';

import 'package:mocktail/mocktail.dart';

class CommentsSpy extends Mock implements Comments {
  When mockAddCommentsCall() => when(() => this.add(any()));
  void mockAddComments() =>
      this.mockAddCommentsCall().thenAnswer((_) async => _);
  void mockAddCommentsError(DomainError error) =>
      this.mockAddCommentsCall().thenThrow(error);

  When mockLoadCommentsCall() => when(() => this.load());
  void mockLoadComments(List<String> comments) =>
      this.mockLoadCommentsCall().thenAnswer((_) async => comments);
  void mockLoadCommentsError(DomainError error) =>
      this.mockLoadCommentsCall().thenThrow(error);
}
