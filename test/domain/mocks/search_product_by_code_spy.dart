// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';

class SearchProductByCodeSpy extends Mock implements SearchProductByCode {
  SearchProductByCodeSpy() {
    mockSearchProductByCode(null);
  }
  When mockSearchProductByCodesCall() => when(() => this.search(
        url: any(named: "url"),
        value: any(named: "value"),
        enterpriseId: any(named: "enterpriseId"),
      ));

  void mockSearchProductByCode(ProductEntity? productEntity) {
    this.mockSearchProductByCodesCall().thenAnswer((_) async => productEntity);
  }

  void mockError(DomainError error) {
    this.mockSearchProductByCodesCall().thenThrow(error);
  }
}
