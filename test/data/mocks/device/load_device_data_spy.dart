// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';

class LoadDeviceDataSpy extends Mock implements LoadDeviceData {
  When _mockGetImeiOrWindowsIdCall() => when(() => this.getImeiOrWindowsId());

  void mockGetImeiOrWindowsId(String identifier) {
    this._mockGetImeiOrWindowsIdCall().thenAnswer((any) async => identifier);
  }

  void mockGetImeiError() {
    this._mockGetImeiOrWindowsIdCall().thenThrow(DomainError.unexpected);
  }

  When _mockGetApplicationVersionCall() =>
      when(() => this.getApplicationVersion());

  void mockGetApplicationVersion(String identifier) {
    this._mockGetApplicationVersionCall().thenAnswer((any) async => identifier);
  }

  void mockGetApplicationVersionError() {
    this._mockGetApplicationVersionCall().thenThrow(DomainError.unexpected);
  }
}
