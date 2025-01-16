import 'package:flutter/foundation.dart';

import '../../../domain/usecases/usecases.dart';
import '../../database/database.dart';

class RemoteUpdateDeviceInformations implements UpdateDeviceInformations {
  final FirebaseStorage firebaseStorage;

  RemoteUpdateDeviceInformations({
    required this.firebaseStorage,
  });

  @override
  Future<void> update(String enterpriseName) async {
    try {
      await firebaseStorage.updateDeviceInformations(enterpriseName);
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
