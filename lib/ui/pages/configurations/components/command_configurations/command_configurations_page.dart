import 'package:flutter/material.dart';

import '../../../pages.dart';

class CommandConfigurationsPage extends StatelessWidget {
  const CommandConfigurationsPage({super.key});

  static final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Form(
            key: formKey,
            child: Column(
              children: [
                SizedBox(height: 10),
                UpdateCommandNumberDropdown(),
                SizedBox(height: 10),
                UpdatePeopleNumbersDropdown(),
                SizedBox(height: 10),
                UpdateSellerDropdown(),
                ConfirmUpdateCommandDataButton(
                  formKey: formKey,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
