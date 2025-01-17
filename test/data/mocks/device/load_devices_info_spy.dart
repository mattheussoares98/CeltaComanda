// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';

class LoadDevicesInfoSpy extends Mock implements LoadDevicesInfo {
  When _mockLoadCall() => when(() => this.load(any()));

  void mockLoad(List<DeviceInfoEntity> devices) {
    this._mockLoadCall().thenAnswer((any) async => devices);
  }

  void mockLoadError(DomainError error) {
    this._mockLoadCall().thenThrow(error);
  }
}
