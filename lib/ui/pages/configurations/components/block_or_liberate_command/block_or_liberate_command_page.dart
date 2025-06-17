import 'package:flutter/material.dart';

import '../../../../../main/builders/builders.dart';
import '../../../../components/components.dart';
import '../../../pages.dart';

class BlockOrLiberateCommandPage extends StatefulWidget {
  const BlockOrLiberateCommandPage({super.key});

  @override
  State<BlockOrLiberateCommandPage> createState() =>
      _BlockOrLiberateCommandPageState();
}

class _BlockOrLiberateCommandPageState
    extends State<BlockOrLiberateCommandPage> {
  final formKey = GlobalKey<FormState>();
  final commandNumberController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    commandNumberController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              CommandField(commandNumberController: commandNumberController),
              const SizedBox(height: 30),
              Row(
                children: [
                  if (EnterpriseBuilder.entity?.verifyCommandBlocked != false)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: BlockOrLiberateButton(
                          commandNumberController: commandNumberController,
                          formKey: formKey,
                          isLiberating: false,
                        ),
                      ),
                    ),
                  Expanded(
                    child: BlockOrLiberateButton(
                      commandNumberController: commandNumberController,
                      formKey: formKey,
                      isLiberating: true,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
