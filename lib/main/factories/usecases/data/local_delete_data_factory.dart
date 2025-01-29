import '../../../../data/usecases/usecases.dart';
import '../../../../domain/usecases/usecases.dart';
import '../../factories.dart';

DeleteData makeLocalDeleteData() => LocalDeleteData(
      hiveStorage: makeHiveAdapter(),
    );
