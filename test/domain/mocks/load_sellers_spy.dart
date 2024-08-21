// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';

class LoadSellersSpy extends Mock implements LoadSellers {
  LoadSellersSpy() {
    this.mockLoadSellers();
  }
  When mocLoadSellersCall() => when(() => this.load());

  void mockLoadSellers() {
    this.mocLoadSellersCall().thenAnswer((_) async => _);
  }

  void mockLoadSellersError() {
    this.mocLoadSellersCall().thenThrow(Exception());
  }
}
