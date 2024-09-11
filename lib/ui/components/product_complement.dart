import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:flutter/material.dart';

class ProductComplement extends StatelessWidget {
  final String? productComplement;
  const ProductComplement({
    required this.productComplement,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (productComplement == null || productComplement?.isEmpty == true) {
      return const SizedBox();
    }
    RegExp optionalRegex = RegExp(r'\(op\|[^|]*\|op\)');
    RegExp obligatoryRegex = RegExp(r'\(ob\|[^|]*\|ob\)');

    String complement = productComplement
        .toString()
        .toLowerCase()
        .replaceAll(optionalRegex, '')
        .replaceAll(obligatoryRegex, '')
        .replaceAll(RegExp(r'\(p\)'), '')
        .replaceAll(RegExp(r'\(pp\)'), '')
        .replaceAll(RegExp(r'\(ppp\)'), '')
        .replaceAll(RegExp(r'\(kids\)'), '')
        .replaceAll(RegExp(r'\(novo\)'), '');

    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(2),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: HtmlWidget(complement),
            ),
          ),
        ],
      ),
    );
  }
}
