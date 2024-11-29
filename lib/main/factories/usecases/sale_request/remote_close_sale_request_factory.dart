import '../../../../data/usecases/usecases.dart';
import '../../../../domain/usecases/usecases.dart';
import '../../factories.dart';

CloseSaleRequest makeRemoteCloseSaleRequest() =>
    RemoteCloseSaleRequest(httpAdapter: makeHttpAdapter());
