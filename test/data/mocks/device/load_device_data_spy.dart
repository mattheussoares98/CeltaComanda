// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/domain/usecases/usecases.dart';
import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';

class LoadDeviceDataSpy extends Mock implements LoadDeviceData {
  LoadDeviceDataSpy() {
    this.mockIsAndroidPlatform(true);
    this.mockIsIOSPlatform(true);
    this.mockGetApplicationVersion(faker.randomGenerator.string(10));
    this.mockGetImeiOrWindowsId(faker.randomGenerator.string(10));
  }
  When _mockGetImeiOrWindowsIdCall() => when(() => this.getImeiOrWindowsId());

  void mockGetImeiOrWindowsId(String imeiOrWindowsId) {
    this
        ._mockGetImeiOrWindowsIdCall()
        .thenAnswer((any) async => imeiOrWindowsId);
  }

  void mockGetImeiError() {
    this._mockGetImeiOrWindowsIdCall().thenThrow(DomainError.unexpected);
  }

  When _mockGetApplicationVersionCall() =>
      when(() => this.getApplicationVersion());

  void mockGetApplicationVersion(String applicationVersion) {
    this
        ._mockGetApplicationVersionCall()
        .thenAnswer((any) async => applicationVersion);
  }

  void mockGetApplicationVersionError() {
    this._mockGetApplicationVersionCall().thenThrow(DomainError.unexpected);
  }

  When _mockIsAndroidPlatformCall() => when(() => this.isAndroidPlatform());
  void mockIsAndroidPlatform(bool value) {
    this._mockIsAndroidPlatformCall().thenAnswer((any) => value);
  }

  When _mockIsIOSPlatformCall() => when(() => this.isIOSPlatform());

  void mockIsIOSPlatform(bool value) {
    this._mockIsIOSPlatformCall().thenAnswer((any) => value);
  }

  void mockIsAndroidPlatformError() {
    this._mockIsAndroidPlatformCall().thenThrow(Exception());
  }
}
