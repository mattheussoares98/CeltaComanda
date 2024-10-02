import '../../../../data/usecases/usecases.dart';
import '../../../../domain/usecases/usecases.dart';
import '../../factories.dart';

FinishSaleRequestTemp makeRemoteFinishSaleRequestTemp() =>
    RemoteFinishSaleRequestTemp(
      httpAdapter: makeHttpAdapter(),
    );
