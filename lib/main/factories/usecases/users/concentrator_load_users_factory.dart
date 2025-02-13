import '../../../../data/usecases/usecases.dart';
import '../../../../domain/usecases/usecases.dart';
import '../../factories.dart';

LoadUsers makeConcentratorLoadUsers() => ConcentratorLoadUsers(
      httpAdapter: makeHttpAdapter(),
      hiveAdapter: makeHiveAdapter(),
    );
