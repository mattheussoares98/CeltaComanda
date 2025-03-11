import '../../../../data/usecases/usecases.dart';
import '../../../../domain/usecases/usecases.dart';
import '../../factories.dart';

SendSaleMovementAsNfce makeBsSendSaleMovementAsNfce() =>
    BsSendSaleMovementAsNfce(soapAdapter: makeSoapAdapter());
