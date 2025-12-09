import '../../../../data/usecases/usecases.dart';
import '../../../../domain/usecases/usecases.dart';
import '../../factories.dart';

ConcLoadSaleRequest makeRemoteConcLoadSaleRequest() =>
    RemoteConcLoadSaleRequest(makeHttpAdapter());
