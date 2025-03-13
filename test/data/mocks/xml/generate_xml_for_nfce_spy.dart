import 'package:clean_celta_mobile/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';

class GenerateXmlForNfceSpy extends Mock implements GenerateXmlForNfce {
  GenerateXmlForNfceSpy() {
    mockGenerate();
  }
  When _mockGenerateCall() => when(() => this.generate(
        couponFiscalNumber: any(named: "couponFiscalNumber"),
        products: any(named: "products"),
        finalizations: any(named: "finalizations"),
        customer: any(named: "customer"),
        cpf: any(named: "cpf"),
        cnpj: any(named: "cnpj"),
        pdvNumber: any(named: "pdvNumber"),
        incrementValue: any(named: "incrementValue"),
      ));

  void mockGenerate() {
    this._mockGenerateCall().thenAnswer((any) async => any);
  }

  void mockGenerateError() {
    this._mockGenerateCall().thenThrow(Exception());
  }
}
