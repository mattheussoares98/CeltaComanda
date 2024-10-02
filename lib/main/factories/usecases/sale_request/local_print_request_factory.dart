import '../../../../data/usecases/usecases.dart';
import '../../cache/cache.dart';

LocalPrintRequest makeLocalPrintRequest() => LocalPrintRequest(
      hiveStorage: makeHiveAdapter(),
    );
