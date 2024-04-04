// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/data/cache/cache.dart';

import 'package:mocktail/mocktail.dart';

class CacheStorageSpy extends Mock implements CacheStorage {
  CacheStorageSpy() {
    this.mockDelete();
    this.mockSave();
  }

  When mockGetCall() => when(() => this.get(any()));
  void mockGet(dynamic json) =>
      this.mockGetCall().thenAnswer((_) async => json);
  void mockGetError() => this.mockGetCall().thenThrow(Exception());

  When mockDeleteCall() => when(() => this.delete(any()));
  void mockDelete() => this.mockDeleteCall().thenAnswer((_) async => _);
  void mockDeleteError() => this.mockDeleteCall().thenThrow(Exception());

  When mockSaveCall() =>
      when(() => this.save(key: any(named: 'key'), value: any(named: 'value')));
  void mockSave() => this.mockSaveCall().thenAnswer((_) async => _);
  void mockSaveError() => this.mockSaveCall().thenThrow(Exception());
}
