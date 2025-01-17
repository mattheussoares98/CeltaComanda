import '../../../../data/usecases/usecases.dart';
import '../../../../domain/usecases/device/device.dart';
import '../../factories.dart';

LoadDevicesInfo makeRemoteLoadDevicesInfo() => RemoteLoadDevicesInfo(
      firebaseStorage: makeFirebaseAdapter(),
    );
