// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/data/database/database.dart';

import 'package:mocktail/mocktail.dart';

class HiveStorageSpy extends Mock implements HiveStorage {
  HiveStorageSpy() {
    this.mockDelete();
    this.mockSave();
  }

  When mockGetCall() => when(() => this.get(any()));
  void mockGet(dynamic data) =>
      this.mockGetCall().thenAnswer((_) async => data);
  void mockGetError() => this.mockGetCall().thenThrow(Exception());

  When mockDeleteCall() => when(() => this.delete(any()));
  void mockDelete() => this.mockDeleteCall().thenAnswer((_) async => _);
  void mockDeleteError() => this.mockDeleteCall().thenThrow(Exception());

  When mockSaveCall() => when(() => this.put(any(), any()));
  void mockSave() => this.mockSaveCall().thenAnswer((_) async => _);
  void mockSaveError() => this.mockSaveCall().thenThrow(Exception());
}
