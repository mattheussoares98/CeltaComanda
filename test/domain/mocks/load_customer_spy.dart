// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';

class LoadCustomerSpy extends Mock implements LoadCustomer {
  When _mockLoadCustomerCall() => when(() => this.load(
        value: any(named: "value"),
        searchTypeInt: any(named: "searchTypeInt"),
      ));

  mockLoadCustomer() {
    _mockLoadCustomerCall().thenAnswer((any) async => any);
  }

  mockLoadCustomerError() {
    _mockLoadCustomerCall().thenThrow(DomainError.unexpected);
  }
}
