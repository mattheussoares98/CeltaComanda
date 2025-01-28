import '../../../../data/usecases/usecases.dart';
import '../../../../domain/usecases/usecases.dart';
import '../../factories.dart';

LoadImages makeConcentratorLoadImages() => ConcentratorLoadImages(
      hiveStorage: makeHiveAdapter(),
      httpClient: makeHttpAdapter(),
    );
