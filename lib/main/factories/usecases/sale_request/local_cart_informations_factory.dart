import '../../../../data/usecases/usecases.dart';
import '../../../../domain/usecases/usecases.dart';
import '../../cache/cache.dart';

CartInformations makeLocalCartInformations() => LocalCartInformations(
      hiveStorage: makeHiveAdapter(),
    );
