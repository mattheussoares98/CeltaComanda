// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:clean_celta_mobile/domain/usecases/usecases.dart';

import 'package:mocktail/mocktail.dart';

class LoadProductsSpy extends Mock implements LoadProducts {
  When mockLoadProductsCall() => when(() => this.load());

  void mockLoadProducts(List<ProductEntity>? products) =>
      this.mockLoadProductsCall().thenAnswer((_) async => products);

  void mockLoadProductsError() =>
      this.mockLoadProductsCall().thenThrow(Exception());
}
