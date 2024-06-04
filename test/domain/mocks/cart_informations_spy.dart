// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/ui/pages/pages.dart';
import 'package:mocktail/mocktail.dart';

import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/domain/usecases/usecases.dart';

class CartInformationsSpy extends Mock implements CartInformations {
  CartInformationsSpy() {
    this.mockClearCart();
  }

  When mockSaveCartCall() => when(() => this.update(any()));
  void mockSaveCart(List<CartProductsViewModel> cartProducts) {
    this.mockSaveCartCall().thenAnswer((_) async => cartProducts);
  }

  void mockSaveError() {
    this.mockSaveCartCall().thenThrow(DomainError.unexpected);
  }

  When mockClearCartCall() => when(() => this.clear());
  void mockClearCart() {
    this.mockClearCartCall().thenAnswer((_) async => _);
  }

  void mockClearError() {
    this.mockClearCartCall().thenThrow(DomainError.unexpected);
  }

  When mockGetCartCall() => when(() => this.get());
  void mockGetCart(List<CartProductsViewModel>? cartProducts) {
    this.mockGetCartCall().thenAnswer((_) async => cartProducts);
  }

  void mockGetError() {
    this.mockGetCartCall().thenThrow(DomainError.unexpected);
  }
}
