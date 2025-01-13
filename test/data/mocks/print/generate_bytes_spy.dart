// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/domain/helpers/domain_error.dart';
import 'package:clean_celta_mobile/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';

class GenerateBytesSpy extends Mock implements GenerateBytes {
  GenerateBytesSpy() {
    this._mockGenerateBytes();
  }
  When _mocGenerateBytesCall() =>
      when(() => this.generateRowWithColumns(any()));

  void _mockGenerateBytes() {
    this._mocGenerateBytesCall().thenAnswer((any) async => any);
  }

  void mockGenerateBytesError() {
    this._mocGenerateBytesCall().thenThrow(DomainError.unexpected);
  }
}
