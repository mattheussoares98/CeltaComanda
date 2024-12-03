import '../../entities/entities.dart';

abstract class PdvRegistration {
  Future<void> getPdvNotUsing();

  Future<List<PdvEntity>> setPdvRegister({
    required int pdvId,
    required String uniqueIdentifier,
    required String versionNumber,
  });
}
