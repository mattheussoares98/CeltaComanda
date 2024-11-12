import 'package:flutter/material.dart';

import '../pages.dart';

class BlockOrLiberateCommandPage extends StatefulWidget {
  const BlockOrLiberateCommandPage({super.key});

  @override
  State<BlockOrLiberateCommandPage> createState() =>
      _BlockOrLiberateCommandPageState();
}

class _BlockOrLiberateCommandPageState
    extends State<BlockOrLiberateCommandPage> {
  int? selectedCommandInDropDown;
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SelectTableDropdown(
              updateSelectedCommand: (value) {
                setState(() {
                  selectedCommandInDropDown = value;
                });
              },
              formKey: formKey,
              selectedCommandInDropDown: selectedCommandInDropDown,
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: BlockOrLiberateButton(
                    commandNumber: selectedCommandInDropDown,
                    formKey: formKey,
                    isLiberating: false,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: BlockOrLiberateButton(
                    commandNumber: selectedCommandInDropDown,
                    formKey: formKey,
                    isLiberating: true,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
