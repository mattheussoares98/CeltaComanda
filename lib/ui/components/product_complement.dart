import 'package:flutter/material.dart';

import '../helpers/helpers.dart';

class ProductComplement extends StatelessWidget {
  final String? productComplement;
  const ProductComplement({
    required this.productComplement,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (productComplement?.isEmpty == true) {
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
        .replaceAll(RegExp(r'\(ppp\)'), '');

    return Expanded(
      flex: 2,
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Text(
            complement,
            maxLines: hasMinWidth(context) ? 4 : 3,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: getStringSize(context),
              color: Theme.of(context).primaryColorDark,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
      ),
    );
  }
}
