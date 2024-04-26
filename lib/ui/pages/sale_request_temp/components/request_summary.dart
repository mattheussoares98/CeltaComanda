import 'package:flutter/material.dart';

class RequestSummary extends StatelessWidget {
  const RequestSummary({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(
            height: 32,
            thickness: 2,
            color: Color(0xFFE0E3E7),
          ),
          const Text(
            'Order Summary',
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 8),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Base Price',
                    ),
                    Text(
                      '\$156.00',
                      textAlign: TextAlign.end,
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 8, 0, 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          const Text(
                            'Total',
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.info_outlined,
                              color: Color(0xFF57636C),
                              size: 18,
                            ),
                            onPressed: () {},
                          ),
                        ],
                      ),
                      const Text(
                        '\$230.20',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
