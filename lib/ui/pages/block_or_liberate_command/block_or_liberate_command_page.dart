import 'package:flutter/material.dart';

import '../../helpers/helpers.dart';
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
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Form(
              key: formKey,
              child: DropdownButtonFormField(
                isExpanded: true,
                alignment: Alignment.center,
                validator: (value) {
                  if (value == null) {
                    return R.string.msgSelectCommand;
                  }

                  return null;
                },
                hint: Text(selectedCommandInDropDown == null
                    ? R.string.msgSelectCommand
                    : "${R.string.table} $selectedCommandInDropDown"),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: getStringSize(context),
                  color: Colors.black,
                ),
                items: List<int>.generate(
                  100,
                  (int index) => index++,
                  growable: true,
                )
                    .map(
                      (e) => DropdownMenuItem(
                        value: e + 1,
                        onTap: () async {},
                        child: Center(
                          child: Text(
                            (e + 1).toString(),
                          ),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (value) async {
                  formKey.currentState?.validate();

                  setState(() {
                    selectedCommandInDropDown = value;
                  });
                },
              ),
            ),
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
