import 'package:flutter/foundation.dart';

import '../../../domain/usecases/usecases.dart';
import '../../database/database.dart';

class RemoteAddPendingDeviceToUpdate implements AddPendingDeviceToUpdate {
  final FirebaseStorage firebaseStorage;

  RemoteAddPendingDeviceToUpdate({
    required this.firebaseStorage,
  });

  @override
  Future<void> add(String imeiOrWindowsId) async {
    try {
      await firebaseStorage.addPendingDeviceToUpdate(imeiOrWindowsId);
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
