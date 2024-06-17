// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/ui/pages/pages.dart';
import 'package:mocktail/mocktail.dart';

import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/domain/usecases/usecases.dart';

class CartInformationsSpy extends Mock implements CartInformations {
  CartInformationsSpy() {
    this.mockClearCart();
    this.mockClearConfirmedsCombox();
  }

  When mockSaveCartCall() => when(() => this.updateCartProducts(any()));
  void mockSaveCart(List<CartProductsViewModel> cartProducts) {
    this.mockSaveCartCall().thenAnswer((_) async => cartProducts);
  }

  void mockSaveError() {
    this.mockSaveCartCall().thenThrow(DomainError.unexpected);
  }

  When mockClearCartCall() => when(() => this.clearCartProducts());
  void mockClearCart() {
    this.mockClearCartCall().thenAnswer((_) async => _);
  }

  void mockClearError() {
    this.mockClearCartCall().thenThrow(DomainError.unexpected);
  }

  When mockGetCartCall() => when(() => this.getCartProducts());
  void mockGetCart(List<CartProductsViewModel>? cartProducts) {
    this.mockGetCartCall().thenAnswer((_) async => cartProducts);
  }

  void mockGetError() {
    this.mockGetCartCall().thenThrow(DomainError.unexpected);
  }

  When mockUpdateConfirmedComboxCall() =>
      when(() => this.updateConfirmedCombox(any()));
  void mockUpdateConfirmedCombox(
      List<ConfirmedComboxViewModel> confirmedsCombox) {
    this
        .mockUpdateConfirmedComboxCall()
        .thenAnswer((_) async => confirmedsCombox);
  }

  void mockUpdateConfirmedComboxError() {
    this.mockUpdateConfirmedComboxCall().thenThrow(DomainError.unexpected);
  }

  When mockClearConfirmedsComboxCall() =>
      when(() => this.clearConfirmedCombox());
  void mockClearConfirmedsCombox() {
    this.mockClearConfirmedsComboxCall().thenAnswer((_) async => _);
  }

  void mockClearConfirmedComboxError() {
    this.mockClearConfirmedsComboxCall().thenThrow(DomainError.unexpected);
  }

  When mockGetConfirmedsComboxCall() => when(() => this.getConfirmedCombox());
  void mockGetConfirmedsCombox(List<ConfirmedComboxViewModel>? confirmedsCombox) {
    this.mockGetConfirmedsComboxCall().thenAnswer((_) async => confirmedsCombox);
  }

  void mockGetConfirmedsComboxError() {
    this.mockGetConfirmedsComboxCall().thenThrow(DomainError.unexpected);
  }
}
