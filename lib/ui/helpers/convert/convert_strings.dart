extension StringModifier on String {
  String toBrazilianNumber(
      [int decimalHouses = 2, bool hideDecimalIfWhole = false]) {
    double value = double.parse(this);

    if (hideDecimalIfWhole && value % 1 == 0) {
      return value
          .toInt()
          .toString()
          .replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => '.');
    }

    String formatted = value.toStringAsFixed(decimalHouses);
    List<String> parts = formatted.split('.');
    parts[0] = parts[0]
        .replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => '.');

    return parts.join(',');
  }

  String addBrazilianCoin() {
    return "R\$ $this";
  }

  String removeWhiteSpaces() {
    return replaceAll(RegExp(r'\s+'), '');
  }

  double toDouble() {
    try {
      if (isEmpty) {
        return -1.0;
      }

      String string = replaceAll(RegExp(r','), '.');
      final quantidadeDePontos = '.'.allMatches(string).length;

      quantidadeDePontos.toString();
      if (quantidadeDePontos > 1) {
        for (var x = 1; x < quantidadeDePontos; x++) {
          if (x < quantidadeDePontos) {
            string = string.replaceFirst(RegExp(r'\.'), '');
          }
        }
      }

      return double.parse(string);
    } catch (e) {
      return -1.0;
    }
  }

  int toInt([bool removePoints = false]) {
    try {
      if (removePoints) {
        return int.parse(
            replaceAll(RegExp(r','), '').replaceAll(RegExp(r'\.'), ''));
      } else {
        return (double.parse(this)).toInt();
      }
    } catch (e) {
      return -1;
    }
  }

  String removeComplementConfigurations() {
    RegExp optionalRegex = RegExp(r'\(op\|[^|]*\|op\)', caseSensitive: false);
    RegExp obligatoryRegex = RegExp(r'\(ob\|[^|]*\|ob\)', caseSensitive: false);

    return this
        .replaceAll(optionalRegex, '')
        .replaceAll(obligatoryRegex, '')
        .replaceAll(RegExp(r'\(p\)', caseSensitive: false), '')
        .replaceAll(RegExp(r'\(pp\)', caseSensitive: false), '')
        .replaceAll(RegExp(r'\(ppp\)', caseSensitive: false), '')
        .replaceAll(RegExp(r'\(kids\)', caseSensitive: false), '')
        .replaceAll(RegExp(r'\(novo\)', caseSensitive: false), '');
  }
}
