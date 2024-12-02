import 'package:flutter/foundation.dart';

import '../../../domain/usecases/usecases.dart';
import '../../database/database.dart';

class RemoteAddPendingDeviceToUpdate implements AddPendingDeviceToUpdate {
  final FirebaseStorage firebaseStorage;

  RemoteAddPendingDeviceToUpdate({
    required this.firebaseStorage,
  });

  @override
  Future<void> add() async {
    try {
      await firebaseStorage.addPendingDeviceToUpdate();
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
