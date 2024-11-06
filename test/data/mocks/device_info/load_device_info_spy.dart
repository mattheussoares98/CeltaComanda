// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';

class LoadDeviceInfoSpy extends Mock implements LoadDeviceInfo {
  When mockDeviceInfoCall() => when(() => this.get());

  void mockDeviceInfo(DeviceInfoEntity entity) {
    this.mockDeviceInfoCall().thenAnswer((_) async => entity);
  }

  void mockError() {
    this.mockDeviceInfoCall().thenThrow(DomainError.unexpected);
  }
}
