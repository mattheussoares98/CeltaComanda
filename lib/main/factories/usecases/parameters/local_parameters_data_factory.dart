import '../../../../data/usecases/usecases.dart';
import '../../../../domain/usecases/usecases.dart';
import '../../factories.dart';

ParametersData makeLocalParametersData() => LocalParametersData(
      hiveStorage: makeHiveAdapter(),
    );
