import 'package:flutter_esc_pos_utils/flutter_esc_pos_utils.dart';

import '../../../domain/usecases/usecases.dart';

class LocalGenerateBytes implements GenerateBytes {
  @override
  Future<List<int>> generateRowWithColumns(List<String> textByColumn) async {
    //TODO create a model to pass in the function with correct params
    try {
      final profile = await CapabilityProfile.load();
      final generator = Generator(PaperSize.mm80, profile);

      List<PosColumn> columns = [];
      for (var column in textByColumn) {
        columns.add(
          PosColumn(
            text: column,
            styles: PosStyles(align: PosAlign.center),
          ),
        );
      }

      return generator.row(columns);
    } catch (e) {
      throw Exception();
    }
  }
}
