import '../../../../data/usecases/usecases.dart';
import '../../../../domain/usecases/usecases.dart';
import '../../factories.dart';

LastImport makeLocalLastImport() => LocalLastImport(
      hiveStorage: makeHiveAdapter(),
    );
