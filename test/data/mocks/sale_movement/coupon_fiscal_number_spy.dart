import 'package:clean_celta_mobile/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';

class CouponFiscalNumberSpy extends Mock implements CouponFiscalNumber {
  CouponFiscalNumberSpy() {
    this.mockSave();
  }
  When _mockSaveCall() => when(() => this.save(any()));

  void mockSave() {
    _mockSaveCall().thenAnswer((_) async => _);
  }

  void mockSaveError() {
    _mockSaveCall().thenThrow(Exception());
  }

  When _mockLoadCall() => when(() => this.load());

  void mockLoad(int value) {
    _mockLoadCall().thenAnswer((_) async => value);
  }

  void mockLoadError() {
    _mockLoadCall().thenThrow(Exception());
  }
}
