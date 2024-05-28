import '../../../domain/entities/entities.dart';

abstract class AddPrintRequest {
  Future<void> add(PrintRequestEntity entity);
}
