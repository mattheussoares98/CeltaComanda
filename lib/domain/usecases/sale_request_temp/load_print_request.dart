import '../../../domain/entities/entities.dart';

abstract class LoadPrintRequest {
  Future<PrintRequestEntity?> getLocalPrintedEntity();
}
