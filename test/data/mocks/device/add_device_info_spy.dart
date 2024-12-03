// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';

class AddDeviceInfoSpy extends Mock implements AddDeviceInfo {
  When _mockDeviceInfoCall() => when(() => this.add(
        commandNumber: any(named: "commandNumber"),
        uniqueIdentifier: any(named: "uniqueIdentifier"),
      ));

  void mockDeviceInfo(int? commandNumber) {
    this._mockDeviceInfoCall().thenAnswer((any) async => any);
  }

  void mockError() {
    this._mockDeviceInfoCall().thenThrow(DomainError.unexpected);
  }
}
