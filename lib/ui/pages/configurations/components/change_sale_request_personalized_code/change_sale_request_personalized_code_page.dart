import 'package:clean_celta_mobile/ui/pages/configurations/components/change_sale_request_personalized_code/change_sale_request_personalized_code.dart';
import 'package:flutter/material.dart';

class ChangeSaleRequestPersonalizedCodePage extends StatefulWidget {
  const ChangeSaleRequestPersonalizedCodePage({super.key});

  @override
  State<ChangeSaleRequestPersonalizedCodePage> createState() =>
      _ChangeSaleRequestPersonalizedCodePageState();
}

class _ChangeSaleRequestPersonalizedCodePageState
    extends State<ChangeSaleRequestPersonalizedCodePage> {
  final formKey = GlobalKey<FormState>();

  int? oldPersonalizedCode;
  void updateOldPersonalizedCode(int? value) {
    setState(() {
      oldPersonalizedCode = value;
    });
  }

  int? newPersonalizedCode;
  void updateNewPersonalizedCode(int? value) {
    setState(() {
      newPersonalizedCode = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
      key: formKey,
      child: Column(
        children: [
          OldPersonalizedCodeDropdown(
            oldPersonalizedCode: oldPersonalizedCode,
            updateOldPersonalizedCode: updateOldPersonalizedCode,
          ),
          const SizedBox(height: 8),
          NewPersonalizedCodeDropdown(
            oldPersonalizedCode: oldPersonalizedCode,
            newPersonalizedCode: newPersonalizedCode,
            updateNewPersonalizedCode: updateNewPersonalizedCode,
          ),
          const SizedBox(height: 8),
          ConfirmUpdateButton(
            oldPersonalizedCode: oldPersonalizedCode,
            newPersonalizedCode: newPersonalizedCode,
            formKey: formKey,
          ),
        ],
      ),
    ));
  }
}
