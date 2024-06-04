// ignore_for_file: unnecessary_this

import 'package:mocktail/mocktail.dart';

import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/domain/usecases/usecases.dart';

class CartInformationsSpy extends Mock implements CartInformations {
  CartInformationsSpy() {
    this.mockSaveCart();
  }

  When mockSaveCartCall() => when(() => this.update(any()));

  void mockSaveCart() {
    this.mockSaveCartCall().thenAnswer((_) async => _);
  }

  void mockError() {
    this.mockSaveCartCall().thenThrow(DomainError.unexpected);
  }
}
