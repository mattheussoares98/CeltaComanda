// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';

class LoadUniqueIdentifierSpy extends Mock implements LoadUniqueIdentifier {
  When _mockGetCall() => when(() => this.get());

  void mockGet(String identifier) {
    this._mockGetCall().thenAnswer((any) async => identifier);
  }

  void mockError() {
    this._mockGetCall().thenThrow(DomainError.unexpected);
  }
}
