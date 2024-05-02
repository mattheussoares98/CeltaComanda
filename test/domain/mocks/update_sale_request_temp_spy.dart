// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/domain/usecases/usecases.dart';
import 'package:clean_celta_mobile/ui/pages/pages.dart';
import 'package:mocktail/mocktail.dart';

class UpdateSaleRequestTempSpy extends Mock implements UpdateSaleRequestTemp {
  UpdateSaleRequestTempSpy() {
    this.mocUpdateSaleRequestTemp(null);
  }

  When mocUpdateSaleRequestTempCall() => when(() => this.update(
        url: any(named: "url"),
        entity: any(named: "entity"),
      ));

  void mocUpdateSaleRequestTemp(SaleRequestTempViewModel? value) {
    this.mocUpdateSaleRequestTempCall().thenAnswer((_) => value);
  }
}
