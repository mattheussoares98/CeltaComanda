// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';

class AddPendingDeviceToUpdateSpy extends Mock
    implements AddPendingDeviceToUpdate {
  When _mockAddCall(String identifier) => when(() => this.add(identifier));

  void mockAdd(String identifier) {
    this._mockAddCall(identifier).thenAnswer((any) async => any);
  }

  void mockError() {
    this._mockAddCall(any()).thenThrow(DomainError.unexpected);
  }
}
