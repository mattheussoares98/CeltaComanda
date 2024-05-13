// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/domain/usecases/usecases.dart';

import 'package:mocktail/mocktail.dart';

class UpdateProductCommentSpy extends Mock implements UpdateProductComment {
  UpdateProductCommentSpy() {
    this.mockUpdateProductComment();
  }
  When mockUpdateProductCommentCall() => when(() => this.update(
        url: any(named: "url"),
        saleRequestProductTempId: any(named: "saleRequestProductTempId"),
        comments: any(named: "comments"),
      ));

  void mockUpdateProductComment() =>
      this.mockUpdateProductCommentCall().thenAnswer((_) async => _);

  void mockUpdateProductCommentError(DomainError error) =>
      this.mockUpdateProductCommentCall().thenThrow(error);
}
