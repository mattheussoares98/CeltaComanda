// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';

class OpenOrBlockadeSpy extends Mock implements OpenOrBlockade {
  OpenOrBlockadeSpy() {
    this.mockOpenOrBlockadeSpy();
  }

  When mockOpenOrBlockadeSpyCall() => when(() => this.blockOrLiberate(
        commandNumber: any(named: "commandNumber"),
        block: any(named: "block"),
      ));

  void mockOpenOrBlockadeSpy() {
    this.mockOpenOrBlockadeSpyCall().thenAnswer((_) async => _);
  }

  void mockError(DomainError error) {
    this.mockOpenOrBlockadeSpyCall().thenThrow(error);
  }
}
