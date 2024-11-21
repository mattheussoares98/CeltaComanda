// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';

class ObtainPlataformSpy extends Mock implements ObtainPlataform {
  ObtainPlataformSpy() {
    mockIsWeb(true);
  }
  When _mockIsWebCall() => when(() => this.isWeb());

  void mockIsWeb(bool value) {
    _mockIsWebCall().thenAnswer((_) => value);
  }
}
