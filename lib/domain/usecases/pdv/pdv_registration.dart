import '../../entities/entities.dart';

abstract class PdvRegistration {
  Future<List<PdvEntity>> getPdvNotUsing();

  Future<void> setPdvRegister({
    required int pdvId,
    required String imeiOrWindowsId,
    required String versionNumber,
  });

  Future<PdvEntity?> getById(int pdvId);

  Future<void> updatePdvRegister({
    required PdvEntity entity,
    required String imeiOrWindowsId,
    required String versionNumber,
  });
}
