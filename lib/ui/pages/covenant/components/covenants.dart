import 'package:flutter/material.dart';

import '../../../helpers/helpers.dart';
import '../../pages.dart';

class Covenants extends StatefulWidget {
  final CustomerViewModel customer;
  const Covenants({
    required this.customer,
    super.key,
  });

  @override
  State<Covenants> createState() => _CovenantsState();
}

class _CovenantsState extends State<Covenants> {
  Map<String, String> selectedCovenant = {};

  void _updateSelectedCovenant(CustomerViewModel customer, String? newValue) {
    setState(() {
      selectedCovenant = {
        customer.Code: newValue.toString(),
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Expanded(
              child: Divider(
                thickness: 0.2,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                R.string.covenants,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: getStringSize(context),
                ),
              ),
            ),
            const Expanded(
              child: Divider(
                thickness: 0.2,
              ),
            ),
          ],
        ),
        ListView.builder(
          shrinkWrap: true,
          itemCount: widget.customer.Covenants.length,
          itemBuilder: (context, index) {
            final covenant = widget.customer.Covenants[index];

            return RadioListTile<String>(
              dense: true,
              visualDensity: VisualDensity.compact,
              title: Text(
                covenant.Name,
                style: TextStyle(
                  fontSize: getStringSize(context),
                ),
              ),
              value: covenant.Code.toString(), // Assume each covenant has an Id
              groupValue: selectedCovenant[widget.customer.Code],
              onChanged: (value) {
                _updateSelectedCovenant(widget.customer, value);
              },
            );
          },
        ),
        ElevatedButton(
          onPressed: selectedCovenant.containsKey(widget.customer.Code)
              ? () async {}
              : null,
          child: Text(
            R.string.liquidateCommand.toUpperCase(),
          ),
        ),
      ],
    );
  }
}
