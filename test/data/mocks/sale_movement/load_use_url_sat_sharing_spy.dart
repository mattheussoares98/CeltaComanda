import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';

class LoadUseUrlSatSharingSpy extends Mock implements LoadUseUrlSatSharing {
  LoadUseUrlSatSharingSpy() {
    mockUse(false);
  }
  When _mockUseCall() => when(() => this.getUse(any()));

  void mockUse(bool use) {
    _mockUseCall().thenAnswer((_) => use);
  }

  void mockError(DomainError error) {
    _mockUseCall().thenThrow(error);
  }
}
