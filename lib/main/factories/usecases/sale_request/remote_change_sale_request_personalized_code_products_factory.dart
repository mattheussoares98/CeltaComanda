import '../../../../data/usecases/usecases.dart';
import '../../../../domain/usecases/usecases.dart';
import '../../factories.dart';

ChangeSaleRequestPersonalizedCodeProducts
    makeRemoteChangeSaleRequestPersonalizedCodeProducts() =>
        RemoteChangeSaleRequestPersonalizedCodeProducts(
          httpAdapter: makeHttpAdapter(),
        );
