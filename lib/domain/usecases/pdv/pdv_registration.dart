import '../../entities/entities.dart';

abstract class PdvRegistration {
  Future<List<PdvEntity>> getPdvNotUsing();

  Future<void> setPdvRegister({
    required int pdvId,
    required String uniqueIdentifier,
    required String versionNumber,
  });
}
