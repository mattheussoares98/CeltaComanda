import '../../../../data/usecases/usecases.dart';
import '../../../../domain/usecases/usecases.dart';
import '../../../../main/factories/cache/cache.dart';

CovenantAuthorizationIsPendant makeLocalCovenantAuthorizationIsPendant() =>
    LocalCovenantAuthorizationIsPendant(
      hiveStorage: makeHiveAdapter(),
    );
