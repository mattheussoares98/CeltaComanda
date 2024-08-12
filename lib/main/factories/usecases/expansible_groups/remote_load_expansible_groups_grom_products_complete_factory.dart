import '../../../../data/usecases/usecases.dart';
import '../../../../domain/usecases/usecases.dart';
import '../../factories.dart';

LoadComments
    makeRemoteLoadExpansibleGroupsFromProductsComplete() =>
        RemoteLoadComments(
          httpAdapter: makeHttpAdapter(),
        );
