import '../../../../data/usecases/usecases.dart';
import '../../../../domain/usecases/usecases.dart';
import '../../http/http.dart';

ConcLoadSaleMovement makeRemoteLoadSaleMovementConcentrator() {
  return RemoteConcLoadSaleMovement(httpAdapter: makeHttpAdapter());
}
