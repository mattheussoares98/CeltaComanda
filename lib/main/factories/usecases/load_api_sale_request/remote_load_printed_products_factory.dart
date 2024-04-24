import '../../../../domain/usecases/usecases.dart';
import '../../../../data/usecases/usecases.dart';
import '../../factories.dart';

LoadSaleRequestPrintedProducts makeRemoteLoadSaleRequestPrintedProducts() =>
    RemoteLoadSaleRequestPrintedProducts(
      httpAdapter: makeHttpAdapter(),
    );
