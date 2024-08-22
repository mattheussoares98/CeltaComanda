// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';

class OpenOrBlockadeSpy extends Mock implements OpenOrBlockade {
  OpenOrBlockadeSpy() {
    this.mockOpenOrBlockade(true);
  }

  When mockOpenOrBlockadeSpyCall() => when(() => this.blockOrLiberate(
        commandNumber: any(named: "commandNumber"),
        block: any(named: "block"),
      ));

  void mockOpenOrBlockade(bool isBlockade) {
    this.mockOpenOrBlockadeSpyCall().thenAnswer((_) async => isBlockade);
  }

  void mockError(DomainError error) {
    this.mockOpenOrBlockadeSpyCall().thenThrow(error);
  }
}
