import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mocktail/mocktail.dart';

class FlutterSecureStorageSpy extends Mock implements FlutterSecureStorage {
  FlutterSecureStorageSpy() {
    mockDelete();
    mockSave();
  }

  When mockDeleteCall() => when(() => delete(key: any(named: 'key')));
  void mockDelete() => mockDeleteCall().thenAnswer((any) async => any);
  void mockDeleteError() => when(() => mockDeleteCall().thenThrow(Exception()));

  When mockSaveCall() => when(() => write(key: any(named: 'key'), value: any(named: 'value')));
  void mockSave() => mockSaveCall().thenAnswer((any) async => any);
  void mockSaveError() => when(() => mockSaveCall().thenThrow(Exception()));

  When mockFetchCall() => when(() => read(key: any(named: 'key')));
  void mockFetch(String? data) => mockFetchCall().thenAnswer((_) async => data);
  void mockFetchError() => when(() => mockFetchCall().thenThrow(Exception()));
}