import '../../entities/entities.dart';

abstract class PdvRegistration {
  Future<List<PdvEntity>> getPdvNotUsing();

  Future<void> setPdvRegister({
    required int pdvId,
    required String imeiOrWindowsId,
    required String versionNumber,
    required String ip,
    required bool isUsing,
  });

  Future<PdvEntity?> getById(int pdvId);
  
  Future<List<PdvEntity>> getByEnterpriseId();

  Future<void> updatePdvRegister({
    required PdvEntity entity,
    required String versionNumber,
  });
}
