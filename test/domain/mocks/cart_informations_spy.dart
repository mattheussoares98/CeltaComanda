// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/ui/pages/pages.dart';
import 'package:mocktail/mocktail.dart';

import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/domain/usecases/usecases.dart';

class CartInformationsSpy extends Mock implements CartInformations {
  When mockSaveCartCall(List<CartProductsViewModel>? cartProducts) =>
      when(() => this.update(cartProducts));

  void mockSaveCart(List<CartProductsViewModel> cartProducts) {
    this.mockSaveCartCall(cartProducts).thenAnswer((_) async => _);
  }

  void mockError(List<CartProductsViewModel>? cartProducts) {
    this.mockSaveCartCall(cartProducts).thenThrow(DomainError.unexpected);
  }
}
