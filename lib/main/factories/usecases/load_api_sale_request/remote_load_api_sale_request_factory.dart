import '../../../../domain/usecases/usecases.dart';
import '../../../../data/usecases/usecases.dart';
import '../../factories.dart';

LoadApiSaleRequest makeRemoteLoadApiSaleRequest() => RemoteLoadApiSaleRequest(
      httpAdapter: makeHttpAdapter(),
      url: makeApiUrl("http://192.168.1.10:10965/api/apiSaleRequest/GetTemp?_enterpriseId=1&_personalizedCode=001"),
    );
