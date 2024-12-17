import 'package:clean_celta_mobile/ui/pages/configurations/components/change_sale_request_personalized_code/change_sale_request_personalized_code.dart';
import 'package:flutter/material.dart';

import '../../../../components/components.dart';
import '../../../../helpers/helpers.dart';

class ChangeSaleRequestPersonalizedCodePage extends StatefulWidget {
  const ChangeSaleRequestPersonalizedCodePage({super.key});

  @override
  State<ChangeSaleRequestPersonalizedCodePage> createState() =>
      _ChangeSaleRequestPersonalizedCodePageState();
}

class _ChangeSaleRequestPersonalizedCodePageState
    extends State<ChangeSaleRequestPersonalizedCodePage> {
  final formKey = GlobalKey<FormState>();
  final oldCommandNumberController = TextEditingController();
  final newCommandNumberController = TextEditingController();

  @override
  void dispose() {
    super.dispose();

    oldCommandNumberController.dispose();
    newCommandNumberController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
      key: formKey,
      child: Column(
        children: [
          CommandField(
            commandNumberController: oldCommandNumberController,
            hintText: R.string.msgOldTable,
            labelText: R.string.msgOldTable,
          ),
          const SizedBox(height: 8),
          CommandField(
            commandNumberController: newCommandNumberController,
            hintText: R.string.msgNewTable,
            labelText: R.string.msgNewTable,
          ),
          const SizedBox(height: 8),
          ConfirmUpdateButton(
            oldCommandNumberController: oldCommandNumberController,
            newCommandNumberController: newCommandNumberController,
            formKey: formKey,
          ),
        ],
      ),
    ));
  }
}
