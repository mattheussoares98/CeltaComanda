import '../../../../domain/usecases/usecases.dart';
import '../../../../data/usecases/usecases.dart';
import '../../factories.dart';

LoadApiSaleRequest makeRemoteLoadApiSaleRequest() => RemoteLoadApiSaleRequest(
      httpAdapter: makeHttpAdapter(),
    );
