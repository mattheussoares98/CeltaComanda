// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';

class PersistentSpy extends Mock implements Persistent {
  PersistentSpy() {
    when(() => this.makePersistent()).thenAnswer((_) async => _);
    when(() => this.makeNotPersistent()).thenAnswer((_) async => _);
    when(() => this.closeApp()).thenAnswer((_) async => _);
  }
}
