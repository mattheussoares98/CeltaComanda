// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/ui/pages/pages.dart';
import 'package:mocktail/mocktail.dart';

import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/domain/usecases/usecases.dart';

class CartInformationsSpy extends Mock implements CartInformations {
  When mockSaveCartCall() => when(() => this.update(any()));

  void mockSaveCart(List<CartProductsViewModel> cartProducts) {
    this.mockSaveCartCall().thenAnswer((_) async => cartProducts);
  }

  void mockError() {
    this.mockSaveCartCall().thenThrow(DomainError.unexpected);
  }
}
