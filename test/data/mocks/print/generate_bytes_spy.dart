// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/domain/helpers/domain_error.dart';
import 'package:clean_celta_mobile/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';

class GenerateBytesSpy extends Mock implements GenerateBytes {
  When _mocGenerateBytesCall() =>
      when(() => this.generateRowWithColumns(any()));

  void mockGenerateBytes(List<int> bytes) {
    this._mocGenerateBytesCall().thenAnswer((any) async => bytes);
  }

  void mockGenerateBytesError() {
    this._mocGenerateBytesCall().thenThrow(DomainError.unexpected);
  }
}
