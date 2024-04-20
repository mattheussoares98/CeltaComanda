// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:clean_celta_mobile/domain/helpers/domain_error.dart';
import 'package:clean_celta_mobile/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';

class LoadApiSaleRequestSpy extends Mock implements LoadApiSaleRequest {
  LoadApiSaleRequestSpy() {
    mockLoadApiSaleRequest(null);
  }
  When mockLoadApiSaleRequestCall() => when(() => this.load(
        enterpriseId: any(named: "enterpriseId"),
        url: any(named: "url"),
      ));

  void mockLoadApiSaleRequest(ApiSaleRequestEntity? entity) {
    this.mockLoadApiSaleRequestCall().thenAnswer((_) async => entity);
  }

  void mockError(DomainError error) {
    this.mockLoadApiSaleRequestCall().thenThrow(error);
  }
}
