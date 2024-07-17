import '../../../../data/usecases/usecases.dart';
import '../../../../domain/usecases/usecases.dart';
import '../../factories.dart';

LoadExpansibleGroupsFromProductsComplete
    makeRemoteLoadExpansibleGroupsFromProductsComplete() =>
        RemoteLoadExpansibleGroupsFromProductsComplete(
          httpAdapter: makeHttpAdapter(),
        );
