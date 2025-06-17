import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';

class SendSaleMovementAsNfceSpy extends Mock implements SendSaleMovementAsNfce {
  When _mockSendCall() => when(() => this.send(any()));

  void mockSend(dynamic response) {
    _mockSendCall().thenAnswer((_) async => response);
  }

  void mockError(DomainError error) {
    _mockSendCall().thenThrow(error);
  }
}
