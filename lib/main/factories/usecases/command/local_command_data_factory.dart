import '../../../../data/usecases/usecases.dart';
import '../../../../domain/usecases/usecases.dart';
import '../../factories.dart';

LocalCommandData makeLocalUseFixedCommandNumber() =>
    LocalLoadCommandData(
      hiveStorage: makeHiveAdapter(),
    );
