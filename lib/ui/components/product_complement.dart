import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../pages/pages.dart';

class ProductComplement extends StatelessWidget {
  final String? productComplement;
  const ProductComplement({
    required this.productComplement,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    HomePresenter homePresenter = Provider.of(context, listen: false);

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
              child: homePresenter.isGeneratingVersionToGetNet
                  ? HtmlWidget(complement)
                  : Text(_parseHtmlString(complement)),
            ),
          ),
        ],
      ),
    );
  }
}

String _parseHtmlString(String complement) {
  final document = RegExp(r'<[^>]*>').allMatches(complement);
  String parsedString = complement;
  for (final match in document) {
    parsedString = parsedString.replaceAll(match.group(0)!, '');
  }

  parsedString = parsedString.replaceAll(RegExp(r'&#xd;&#xa;'), '\n');
  parsedString = parsedString.replaceAll(RegExp(r'&#.*?;'), '');

  return parsedString;
}
