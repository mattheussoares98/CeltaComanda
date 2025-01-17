import '../../../../data/usecases/usecases.dart';
import '../../../../domain/usecases/usecases.dart';
import '../../factories.dart';

DeleteEnterprise makeRemoteDeleteEnterprise() => RemoteDeleteEnterprise(
      firebaseAdapter: makeFirebaseAdapter(),
    );
