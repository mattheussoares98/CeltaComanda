import '../../../../data/usecases/usecases.dart';
import '../../../../domain/usecases/usecases.dart';
import '../../factories.dart';

CheckPasswordByCustomerCode makeRemoteCheckPasswordByCustomerCode() =>
    RemoteCheckPasswordByCustomerCode(soapAdapter: makeSoapAdapter());
