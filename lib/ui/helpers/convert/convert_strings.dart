extension StringModifier on String {
  String toBrazilianNumber([decimalHouses = 2]) {
    double value = double.parse(this);
    String formatted = value.toStringAsFixed(decimalHouses);

    // Converte para o formato brasileiro
    List<String> parts = formatted.split('.');
    parts[0] = parts[0]
        .replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => '.');
    return parts.join(',');
  }

  String toBrazilianPrice() {
    return "$this R\$";
  }
}
