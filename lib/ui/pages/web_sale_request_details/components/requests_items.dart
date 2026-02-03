// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import '../../../../data/models/models.dart';
import '../../../helpers/helpers.dart';
import 'components.dart';

class RequestsItems extends StatelessWidget {
  final DateTime? Function(List<ConcSaleRequestModel> sales)
      findMostRecentDateFromSales;
  final List<ConcSaleRequestModel> requests;
  final bool isPreparingColumn;

  const RequestsItems({
    super.key,
    required this.findMostRecentDateFromSales,
    required this.requests,
    required this.isPreparingColumn,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = isPreparingColumn ? Colors.amber : Colors.green;

    return Container(
      color: color.withAlpha(20),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Text(
              isPreparingColumn ? R.string.preparing : R.string.ready,
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineLarge?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    const Shadow(
                      color: Colors.black12,
                      offset: Offset(1, 1),
                    ),
                  ]),
            ),
          ),
          ResponsiveListFlow(
            isSliver: true,
            itemCount: requests.length,
            itemBuilder: (_, index) {
              final saleRequest = requests[index];

              final mostRecentRequestFromCurrentSale =
                  findMostRecentDateFromSales([saleRequest]);

              // return const Text('working');

              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      CommandTableAndLastChangedTime(
                        saleRequest: saleRequest,
                        mostRecentRequestFromCurrentSale:
                            mostRecentRequestFromCurrentSale!,
                      ),
                      const Divider(thickness: 0.1),
                      ProductsItems(saleRequest: saleRequest),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
