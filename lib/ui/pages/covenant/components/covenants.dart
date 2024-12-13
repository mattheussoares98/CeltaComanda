// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import '../../../helpers/helpers.dart';
import '../../pages.dart';

class Covenants extends StatefulWidget {
  final CustomerViewModel customer;
  final void Function() callSetState;
  const Covenants({
    required this.customer,
    required this.callSetState,
    super.key,
  });

  @override
  State<Covenants> createState() => _CovenantsState();
}

class _CovenantsState extends State<Covenants> {
  final passwordKey = GlobalKey<FormState>();
  final passwordController = TextEditingController();

  @override
  dispose() {
    super.dispose();

    passwordController.dispose();
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
                  fontSize: StringSize.size,
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
          itemCount: widget.customer.CustomerCovenants?.length,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final covenant = widget.customer.CustomerCovenants?[index];

            return CovenantRadioListTile(
              customer: widget.customer,
              callSetState: widget.callSetState,
              covenant: covenant,
            );
          },
        ),
        ConfirmPayment(
          customer: widget.customer,
          passwordController: passwordController,
          passwordKey: passwordKey,
        ),
      ],
    );
  }
}
