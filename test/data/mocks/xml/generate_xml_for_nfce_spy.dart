import 'package:clean_celta_mobile/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';

class GenerateXmlForNfceSpy extends Mock implements GenerateXmlForNfce {
  When _mockGenerateCall() => when(() => this.generate(
        couponFiscalNumber: any(named: "couponFiscalNumber"),
        products: any(named: "products"),
        finalizations: any(named: "finalizations"),
        customer: any(named: "customer"),
        cpfCnpj: any(named: "cpfCnpj"),
        pdvNumber: any(named: "pdvNumber"),
        incrementValue: any(named: "incrementValue"),
      ));

  void mockGenerate(String value) {
    this._mockGenerateCall().thenAnswer((any) async => value);
  }

  void mockGenerateError() {
    this._mockGenerateCall().thenThrow(Exception());
  }
}
