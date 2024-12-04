// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';

class LoadDeviceDataSpy extends Mock implements LoadDeviceData {
  When _mockGetImeiOrWindowsIdCall() => when(() => this.getImeiOrWindowsId());

  void mockGetImeiOrWindowsId(String imeiOrWindowsId) {
    this._mockGetImeiOrWindowsIdCall().thenAnswer((any) async => imeiOrWindowsId);
  }

  void mockGetImeiError() {
    this._mockGetImeiOrWindowsIdCall().thenThrow(DomainError.unexpected);
  }

  When _mockGetApplicationVersionCall() =>
      when(() => this.getApplicationVersion());

  void mockGetApplicationVersion(String applicationVersion) {
    this._mockGetApplicationVersionCall().thenAnswer((any) async => applicationVersion);
  }

  void mockGetApplicationVersionError() {
    this._mockGetApplicationVersionCall().thenThrow(DomainError.unexpected);
  }
}
