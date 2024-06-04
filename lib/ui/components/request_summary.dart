import 'package:flutter/material.dart';

import '../../ui/components/components.dart';

class RequestSummary extends StatelessWidget {
  final String totalLiquid;
  final String? comments;
  const RequestSummary({
    required this.totalLiquid,
    required this.comments,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Text(
                "$totalLiquid R\$",
                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (comments != null)
            CommentRichText(
              comment: comments!,
            ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
