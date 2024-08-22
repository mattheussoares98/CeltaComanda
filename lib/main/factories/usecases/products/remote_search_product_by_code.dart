import '../../../../data/usecases/usecases.dart';
import '../../../../domain/usecases/usecases.dart';
import '../../factories.dart';

SearchProductByCode makeRemoteSearchProductByCode() =>
    RemoteSearchProductByCode(
      httpAdapter: makeHttpAdapter(),
    );
