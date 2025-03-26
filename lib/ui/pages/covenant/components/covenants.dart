// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
  final cpfCnpjKey = GlobalKey<FormState>();
  final passwordController = TextEditingController();
  final cpfCnpjController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        PaymentPresenter paymentPresenter = Provider.of(context, listen: false);
        cpfCnpjController.text = paymentPresenter.cpfCnpj.toString();
      }
    });
  }

  @override
  dispose() {
    super.dispose();

    passwordController.dispose();
    cpfCnpjController.dispose();
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
          cpfCnpjController: cpfCnpjController,
          cpfCnpjKey: cpfCnpjKey,
        ),
      ],
    );
  }
}
