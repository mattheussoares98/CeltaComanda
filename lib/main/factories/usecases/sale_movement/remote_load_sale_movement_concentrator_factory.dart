import '../../../../data/usecases/usecases.dart';
import '../../../../domain/usecases/usecases.dart';
import '../../http/http.dart';

LoadSaleMovementConcentrator makeRemoteLoadSaleMovementConcentrator() {
  return RemoteLoadSaleMovementConcentrator(httpAdapter: makeHttpAdapter());
}
