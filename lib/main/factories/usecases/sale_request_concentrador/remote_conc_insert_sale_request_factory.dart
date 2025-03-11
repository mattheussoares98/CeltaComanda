import '../../../../data/usecases/usecases.dart';
import '../../../../domain/usecases/usecases.dart';
import '../../factories.dart';

ConcInsertSaleMovement makeRemoteConcInsertSaleMovement() =>
    RemoteConcInsertSaleMovement(
      httpAdapter: makeHttpAdapter(),
    );
