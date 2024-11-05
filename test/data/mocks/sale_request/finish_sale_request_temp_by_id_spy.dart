// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/domain/usecases/usecases.dart';

import 'package:mocktail/mocktail.dart';

class FinishSaleRequestTempByIdSpy extends Mock
    implements FinishSaleRequestTempById {
  FinishSaleRequestTempByIdSpy() {
    this.mockFinish();
  }
  When mockFinishCall() => when(() => this.finish(any()));

  void mockFinish() => this.mockFinishCall().thenAnswer((any) async => any);

  void mockFinishError() =>
      this.mockFinishCall().thenThrow(DomainError.unexpected);
}
