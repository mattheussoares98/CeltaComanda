import '../../../../data/usecases/usecases.dart';
import '../../../../domain/usecases/usecases.dart';
import '../../factories.dart';

UpdatedAllImages makeLocalUpdatedAllImages() => LocalUpdatedAllImages(
      hiveStorage: makeHiveAdapter(),
    );
