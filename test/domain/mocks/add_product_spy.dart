// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';

class AddProductSpy extends Mock implements AddProduct {
  When mockAddProductCall() => when(() => this.add(any()));

  void mockAddProduct() {
    mockAddProductCall().thenAnswer((_) async => _);
  }
}
