// ignore_for_file: unnecessary_this

import 'package:hive/hive.dart';
import 'package:mocktail/mocktail.dart';

import 'mocks.dart';

class HiveSpy extends Mock implements HiveInterface {
  When mockOpenBoxCall() => when(() => this.openBox(any()));
  void mockOpenBox(BoxSpy box) =>
      this.mockOpenBoxCall().thenAnswer((_) async => box);
}

// class HiveSpy extends Mock implements Box<dynamic>, HiveInterface {
//   When mockDeleteCall() => when(() => this.delete(any()));
//   void mockDelete(String key) => this.mockDeleteCall().thenAnswer((_) async => _);
//   void mockDeleteError() => when(() => this.mockDeleteCall().thenThrow(Exception()));

//   When mockInitCall() => when(() => this.init(any()));
//   void mockInit(String name) => this.mockInitCall().thenAnswer((_) async => _);

//   When mockOpenBoxCall() => when(() => this.openBox(any()));
//   void mockOpenBox() => this.mockOpenBoxCall().thenAnswer((_) async => _);

//   When mockPutCall() => when(() => this.put(any(), any()));
//   void mockPut(String key, String value) =>
//       this.mockPutCall().thenAnswer((_) async => _);
//   void mockPutError() => when(() => this.mockPutCall().thenThrow(Exception()));

//   When mockGetCall() => when(() => this.get(any()));
//   void mockGet(dynamic data) => this.mockGetCall().thenAnswer((_) async => data);
//   void mockGetError() => when(() => this.mockGetCall().thenThrow(Exception()));
// }
