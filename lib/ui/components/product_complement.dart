// [HTML-WIDGET-ACTIVE-START]
import 'package:clean_celta_mobile/presentation/helpers/app_platform.dart';
// [HTML-WIDGET-ACTIVE-END]
import 'package:flutter/material.dart';
// [HTML-WIDGET-ACTIVE-START]
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
// [HTML-WIDGET-ACTIVE-END]

import '../../../ui/helpers/helpers.dart';

class ProductComplement extends StatelessWidget {
  final String? productComplement;
  const ProductComplement({
    required this.productComplement,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (productComplement == null ||
        productComplement?.isEmpty == true ||
        productComplement!.removeComplementConfigurations().isEmpty) {
      return const SizedBox();
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(2),
            child: Align(
              alignment: Alignment.bottomCenter,
// [HTML-WIDGET-ACTIVE-START]
              child: activePlatform == AppPlatform.tablet
                  ? Text(_parseHtmlString(
                      productComplement!.removeComplementConfigurations()))
                  : HtmlWidget(
                      productComplement!.removeComplementConfigurations()),
// [HTML-WIDGET-ACTIVE-END]
// [HTML-WIDGET-INACTIVE-START]
              // child: Text(_parseHtmlString(
                  // productComplement!.removeComplementConfigurations())),
// [HTML-WIDGET-INACTIVE-END]
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
