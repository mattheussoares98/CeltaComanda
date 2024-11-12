import '../../../../main/factories/factories.dart';
import '../../../../data/usecases/usecases.dart';
import '../../../../domain/usecases/usecases.dart';

UpdateMenu makeRemoteUpdateMenu() => RemoteUpdateMenu(
      firebaseAdapter: makeFirebaseAdapter(),
    );
