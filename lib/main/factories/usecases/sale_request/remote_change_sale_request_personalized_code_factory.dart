import '../../../../data/usecases/usecases.dart';
import '../../../../domain/usecases/usecases.dart';
import '../../factories.dart';

ChangeSaleRequestPersonalizedCode makeRemoteChangeSaleRequestPersonalizedCode() =>
    RemoteChangeSaleRequestPersonalizedCode(
      httpAdapter: makeHttpAdapter(),
    );
