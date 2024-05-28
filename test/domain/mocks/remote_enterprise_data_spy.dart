// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/data/usecases/usecases.dart';
import 'package:clean_celta_mobile/domain/entities/entities.dart';

import 'package:mocktail/mocktail.dart';

class RemoteEnterpriseDataSpy extends Mock implements RemoteLoadEnterpriseData {
  // When mockAddCall() => when(() => this.add(any()));
  // void mockAdd(EnterpriseDataEntity entity) =>
  //     this.mockAddCall().thenAnswer((_) async => entity);
  // void mockSaveError() => this.mockAddCall().thenThrow(DomainError.unexpected);

  When mockRemoteLoadDataCall() =>
      when(() => this.load());
  void mockRemoteLoad(EnterpriseEntity? entity) =>
      this.mockRemoteLoadDataCall().thenAnswer((_) async => entity);
  void mockRemoteLoadError() => this.mockRemoteLoadDataCall().thenThrow(Exception());
}
