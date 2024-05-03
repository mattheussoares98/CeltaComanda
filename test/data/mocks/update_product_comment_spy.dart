// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:clean_celta_mobile/domain/usecases/usecases.dart';

import 'package:mocktail/mocktail.dart';

class UpdateProductCommentSpy extends Mock implements UpdateProductComment {
  When mockUpdateProductCommentCall() => when(() => this.update(
        url: any(named: "url"),
        saleRequestProductTempId: any(named: "saleRequestProductTempId"),
        comments: any(named: "comments"),
      ));

  void mockUpdateProductComment(List<ProductEntity>? products) =>
      this.mockUpdateProductCommentCall().thenAnswer((_) async => products);

  void mockUpdateProductCommentError() =>
      this.mockUpdateProductCommentCall().thenThrow(Exception());
}
