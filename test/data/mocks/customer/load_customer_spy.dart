// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';

class LoadCustomerSpy extends Mock implements LoadCustomer {
  When _mockLoadCustomerCall() => when(() => this.load(
        value: any(named: "value"),
        searchTypeInt: any(named: "searchTypeInt"),
      ));

  void mockLoadCustomer(List<CustomerEntity>? result) {
    _mockLoadCustomerCall().thenAnswer((any) async => result);
  }

  void mockError() {
    _mockLoadCustomerCall().thenThrow(DomainError.unexpected);
  }
}
