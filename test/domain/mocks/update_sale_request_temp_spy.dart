// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/domain/helpers/domain_error.dart';
import 'package:clean_celta_mobile/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';

class UpdateSaleRequestTempSpy extends Mock implements UpdateSaleRequestTemp {
  When mocUpdateSaleRequestTempCall() => when(() => this.update(
        url: any(named: "url"),
        entity: any(named: "entity"),
      ));

  void mockUpdateSaleRequestTemp() {
    this.mocUpdateSaleRequestTempCall().thenAnswer((_) async => _);
  }

  void mockUpdateSaleRequestTempError(){
    this.mocUpdateSaleRequestTempCall().thenThrow(DomainError.unexpected);
  }
}
