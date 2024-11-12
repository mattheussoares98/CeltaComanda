import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/components.dart';
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
    ConfigurationsPresenter configurationsPresenter =
        Provider.of(context, listen: false);

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
                  child: ElevatedButton(
                    onPressed: () async {
                      await _openOrBlock(
                        formKey: formKey,
                        configurationsPresenter: configurationsPresenter,
                        liberate: false,
                        context: context,
                        commandNumber: selectedCommandInDropDown,
                      );
                    },
                    child: Text(
                      R.string.blockCommand,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      await _openOrBlock(
                        formKey: formKey,
                        configurationsPresenter: configurationsPresenter,
                        liberate: true,
                        context: context,
                        commandNumber: selectedCommandInDropDown,
                      );
                    },
                    child: Text(
                      R.string.liberateCommand,
                    ),
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

Future<void> _openOrBlock({
  required ConfigurationsPresenter configurationsPresenter,
  required bool liberate,
  required BuildContext context,
  required int? commandNumber,
  required GlobalKey<FormState> formKey,
}) async {
  bool? isValid = formKey.currentState?.validate();

  if (isValid != true) {
    return;
  }

  final updated = await configurationsPresenter.openOrBlockadeCommand(
    commandNumber: commandNumber!,
    isOpen: liberate,
  );

  if (updated) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      FocusScope.of(context).unfocus();
      snackBarMessage(
        context,
        liberate ? R.string.msgReleasesCommand : R.string.msgBlockedCommand,
        backgroundColor: Theme.of(context).secondaryHeaderColor,
      );
    });
  }
}
