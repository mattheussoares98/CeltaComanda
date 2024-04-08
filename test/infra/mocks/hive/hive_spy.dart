// ignore_for_file: unnecessary_this

import 'package:hive/hive.dart';
import 'package:mocktail/mocktail.dart';

import '../mocks.dart';

class HiveSpy extends Mock implements HiveInterface {
  When mockOpenBoxCall() => when(() => this.openBox(any()));
  void mockOpenBox(BoxSpy box) =>
      this.mockOpenBoxCall().thenAnswer((_) async => box);
}
