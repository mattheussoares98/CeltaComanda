// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/domain/usecases/usecases.dart';
import 'package:clean_celta_mobile/infra/helpers/helpers.dart';
import 'package:mocktail/mocktail.dart';

class LoadCustomerSpy extends Mock implements LoadCustomer {
  When _mockLoadCustomerCall() => when(() => this.load(
        value: any(named: "value"),
        searchByPersonalizedCode: any(named: "searchByPersonalizedCode"),
      ));

  void mockLoadCustomer(dynamic result) {
    _mockLoadCustomerCall().thenAnswer((any) async => result);
  }

  void mockError(String message) {
    _mockLoadCustomerCall().thenThrow(BsError(message));
  }
}
