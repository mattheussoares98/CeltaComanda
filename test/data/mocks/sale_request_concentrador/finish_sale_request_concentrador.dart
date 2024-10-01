// ignore_for_file: unnecessary_this
import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:mocktail/mocktail.dart';

import 'package:clean_celta_mobile/domain/usecases/usecases.dart';

class FinishSaleRequestConcentradorSpy extends Mock
    implements FinishSaleRequestConcentrador {
  FinishSaleRequestConcentradorSpy() {
    this._mockFinish();
  }

  When _mockFinishCall() => when(() => this.finish(
        enterpriseId: any(named: "enterpriseId"),
        pdvNumber: any(named: "pdvNumber"),
        commandNumber: any(named: "commandNumber"),
      ));
  void _mockFinish() => this._mockFinishCall().thenAnswer((any) async => any);
  void mockFinishError() =>
      this._mockFinishCall().thenThrow(DomainError.unexpected);
}
