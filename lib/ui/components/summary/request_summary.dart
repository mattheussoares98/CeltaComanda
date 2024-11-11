import 'package:flutter/material.dart';

import 'service_charge.dart';
import 'subtotal.dart';
import 'total.dart';

class RequestSummary extends StatelessWidget {
  final double serviceChargeValue;
  final double totalLiquid;
  const RequestSummary({
    required this.serviceChargeValue,
    required this.totalLiquid,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color.fromARGB(255, 220, 218, 218)),
        boxShadow: const [
          BoxShadow(
            blurRadius: 10,
            color: Color(0x33000000),
            offset: Offset(-3, -1),
          )
        ],
        borderRadius: BorderRadius.circular(12),
      ),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              flex: 2,
              child: serviceChargeValue <= 0
                  ? SizedBox()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Subtotal(totalLiquid: totalLiquid),
                        const SizedBox(height: 10),
                        const ServiceCharge(),
                      ],
                    ),
            ),
            if (serviceChargeValue > 0)
              VerticalDivider(
                color: Theme.of(context).primaryColorLight,
                thickness: 1,
              ),
            Expanded(
              child: Total(totalLiquid: totalLiquid),
            ),
          ],
        ),
      ),
    );
  }
}
