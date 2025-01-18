import 'package:flutter/foundation.dart';

import '../../../domain/usecases/usecases.dart';
import '../../database/database.dart';

class RemoteAddPendingDeviceToUpdate implements AddPendingDeviceToUpdate {
  final FirebaseStorage firebaseStorage;

  RemoteAddPendingDeviceToUpdate({
    required this.firebaseStorage,
  });

  @override
  Future<void> add({
    required String imeiOrWindowsId,
    required String enterpriseName,
  }) async {
    try {
      await firebaseStorage.addPendingDeviceToUpdate(
        imeiOrWindowsId: imeiOrWindowsId,
        enterpriseName: enterpriseName,
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
