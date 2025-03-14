import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';

class DeleteSaleRequestSpy extends Mock implements DeleteSaleRequest {
  When _mockCall() => when(() => this.delete(any()));

  void mockDelete() {
    this._mockCall().thenAnswer((_) async => _);
  }

  void mockError(DomainError error) {
    this._mockCall().thenThrow(error);
  }
}
