import 'package:flutter/material.dart';

import '../../../../components/components.dart';
import '../../../../helpers/helpers.dart';
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
                  Expanded(
                    child: BlockOrLiberateButton(
                      commandNumber: commandNumberController.text.toInt(),
                      formKey: formKey,
                      isLiberating: false,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: BlockOrLiberateButton(
                      commandNumber: commandNumberController.text.toInt(),
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
