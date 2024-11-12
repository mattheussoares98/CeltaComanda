// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:clean_celta_mobile/domain/helpers/domain_error.dart';
import 'package:clean_celta_mobile/domain/usecases/usecases.dart';

import 'package:mocktail/mocktail.dart';

class ManageProductScheduleSpy extends Mock implements ManageProductSchedule {
  ManageProductScheduleSpy() {
    mockInsert();
    mockDelete();
  }

  When _mockGetCall() => when(() => this.get(any()));
  void mockGet(List<ProductScheduleEntity> schedules) =>
      this._mockGetCall().thenAnswer((_) async => schedules);
  void mockGetError() => this._mockGetCall().thenThrow(DomainError.unexpected);

  When _mockInsertCall() => when(() => this.insertUpdate(any()));
  void mockInsert() => this._mockInsertCall().thenAnswer((any) async => any);
  void mockInsertError() =>
      this._mockInsertCall().thenThrow(DomainError.unexpected);

  When _mockDeleteCall() => when(() => this.delete(any()));
  void mockDelete() => this._mockDeleteCall().thenAnswer((any) async => any);
  void mockDeleteError() =>
      this._mockDeleteCall().thenThrow(DomainError.unexpected);
}
