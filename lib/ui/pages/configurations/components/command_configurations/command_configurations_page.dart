import 'package:flutter/material.dart';

import '../../../../components/components.dart';
import '../../../pages.dart';

class CommandConfigurationsPage extends StatefulWidget {
  const CommandConfigurationsPage({super.key});

  static final formKey = GlobalKey<FormState>();

  @override
  State<CommandConfigurationsPage> createState() =>
      _CommandConfigurationsPageState();
}

class _CommandConfigurationsPageState extends State<CommandConfigurationsPage> {
  final commandNumberController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    commandNumberController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: CommandConfigurationsPage.formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10),
              CommandField(commandNumberController: commandNumberController),
              SizedBox(height: 10),
              UpdatePeopleNumbersDropdown(),
              SizedBox(height: 10),
              UpdateSellerDropdown(),
              ConfirmUpdateCommandDataButton(
                formKey: CommandConfigurationsPage.formKey,
                commandNumberController: commandNumberController,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
