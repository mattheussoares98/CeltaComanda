import 'package:flutter_esc_pos_utils/flutter_esc_pos_utils.dart';

import '../../../domain/usecases/usecases.dart';
import '../../models/models.dart';

class LocalGenerateBytes implements GenerateBytes {
  @override
  Future<List<int>> generateRowWithColumns(
    List<PrintParametersModel> columnsParameters,
  ) async {
    try {
      final profile = await CapabilityProfile.load();
      final generator = Generator(PaperSize.mm80, profile);

      List<PosColumn> columns = [];
      for (var column in columnsParameters) {
        columns.add(
          PosColumn(
            text: column.text,
            width: column.width,
            styles: PosStyles(
              align: column.alignCenter ? PosAlign.center : PosAlign.left,
              bold: column.bold,
            ),
          ),
        );
      }

      return generator.row(columns);
    } catch (e) {
      throw Exception();
    }
  }
}
