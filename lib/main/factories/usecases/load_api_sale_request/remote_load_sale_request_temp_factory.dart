import '../../../../domain/usecases/usecases.dart';
import '../../../../data/usecases/usecases.dart';
import '../../factories.dart';

LoadSaleRequestTemp makeRemoteLoadSaleRequestTemp() => RemoteLoadSaleRequestTemp(
      httpAdapter: makeHttpAdapter(),
    );
