import 'package:clean_celta_mobile/data/database/database.dart';

import 'package:mocktail/mocktail.dart';

class SecureCacheStorageSpy extends Mock
    implements
        FetchSecureCacheStorage,
        DeleteSecureCacheStorage,
        SaveSecureCacheStorage {
  SecureCacheStorageSpy() {
    mockDelete();
    mockSave();
  }

  When mockFetchCall() => when(() => fetch(any()));
  void mockFetch(String? data) => mockFetchCall().thenAnswer((_) async => data);
  void mockFetchError() => mockFetchCall().thenThrow(Exception());

  When mockDeleteCall() => when(() => delete(any()));
  void mockDelete() => mockDeleteCall().thenAnswer((any) async => any);
  void mockDeleteError() => mockDeleteCall().thenThrow(Exception());

  When mockSaveCall() =>
      when(() => save(key: any(named: 'key'), value: any(named: 'value')));
  void mockSave() => mockSaveCall().thenAnswer((any) async => any);
  void mockSaveError() => mockSaveCall().thenThrow(Exception());
}
