// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';

class PersistentSpy extends Mock implements Persistent {
  PersistentSpy() {
    when(() => this.makePersistent()).thenAnswer((any) async => any);
    when(() => this.makeNotPersistent()).thenAnswer((any) async => any);
    when(() => this.closeApp()).thenAnswer((any) async => any);
  }
}
