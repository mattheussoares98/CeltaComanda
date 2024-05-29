import '../../../../data/usecases/usecases.dart';
import '../../../../main/factories/cache/cache.dart';

LocalPrintRequest makeLocalPrintRequest() => LocalPrintRequest(
      hiveStorage: makeHiveAdapter(),
    );
