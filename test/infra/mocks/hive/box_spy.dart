// ignore_for_file: unnecessary_this

import 'package:hive/hive.dart';
import 'package:mocktail/mocktail.dart';

class BoxSpy extends Mock implements Box {
  When mockGetCall() => when(() => this.get(any()));
  void mockGet(dynamic data) =>
      this.mockGetCall().thenAnswer((_) async => data);
  void mockGetError() => when(() => this.mockGetCall().thenThrow(Exception()));

  When mockPutCall() => when(() => this.put(any(), any()));
  void mockPut(String key, String value) =>
      this.mockPutCall().thenAnswer((_) async => _);
  void mockPutError() => when(() => this.mockPutCall().thenThrow(Exception()));

  When mockDeleteCall() => when(() => this.delete(any()));
  void mockDelete(String key) =>
      this.mockDeleteCall().thenAnswer((_) async => _);
  void mockDeleteError() =>
      when(() => this.mockDeleteCall().thenThrow(Exception()));
}
