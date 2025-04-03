// ignore_for_file: unnecessary_this
import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:mocktail/mocktail.dart';

import 'package:clean_celta_mobile/domain/usecases/usecases.dart';

class ConcInsertSaleMovementSpy extends Mock implements ConcInsertSaleMovement {
  When _mockInsertCall() => when(() => this.insert(
        pdvId: any(named: "pdvId"),
        commandNumber: any(named: "commandNumber"),
        couponFiscalNumber: any(named: "couponFiscalNumber"),
        pdvNumber: any(named: "pdvNumber"),
        covenantCode: any(named: "covenantCode"),
        customerCode: any(named: "customerCode"),
        cpfCnpj: any(named: "cpfCnpj"),
        incrementType: any(named: "incrementType"),
        incrementValue: any(named: "incrementValue"),
        totalLiquid: any(named: "totalLiquid"),
        finalizations: any(named: "finalizations"),
        products: any(named: "products"),
        xmlToGenerateFiscal: any(named: "xmlToGenerateFiscal"),
      ));
  void mockInsert(int value) => this._mockInsertCall().thenAnswer((any) async => value);
  void mockInsertError() =>
      this._mockInsertCall().thenThrow(DomainError.unexpected);
}
