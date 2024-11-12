// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';

class UpdateMenuSpy extends Mock implements UpdateMenu {
  UpdateMenuSpy() {
    when(() => this.update()).thenAnswer((any) async => any);
  }
}
