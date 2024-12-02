// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';

class AddPendingDeviceToUpdateSpy extends Mock
    implements AddPendingDeviceToUpdate {
  When _mockAddCall() => when(() => this.add());

  void mockAddPendingDevice() {
    this._mockAddCall().thenAnswer((any) async => any);
  }

  void mockError() {
    this._mockAddCall().thenThrow(DomainError.unexpected);
  }
}
