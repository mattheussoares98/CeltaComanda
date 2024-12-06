import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../helpers/helpers.dart';
import '../../pages.dart';

class PdvNotUsingDropdown extends StatefulWidget {
  final bool isFixedCommandNumber;
  final TextEditingController commandNumberController;
  final PdvNotUsingViewModel? selectedPdv;
  final void Function(PdvNotUsingViewModel? pdv) updateSelectedPdv;
  const PdvNotUsingDropdown({
    required this.isFixedCommandNumber,
    required this.commandNumberController,
    required this.selectedPdv,
    required this.updateSelectedPdv,
    super.key,
  });

  @override
  State<PdvNotUsingDropdown> createState() => _PdvNotUsingDropdownState();
}

class _PdvNotUsingDropdownState extends State<PdvNotUsingDropdown> {
  @override
  Widget build(BuildContext context) {
    EnterprisePresenter enterprisePresenter =
        Provider.of(context, listen: false);

    return StreamBuilder(
        stream: enterprisePresenter.pdvsNotUsingStream,
        builder: (context, snapshot) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: DropdownButtonFormField<PdvNotUsingViewModel?>(
                  validator: (value) {
                    return null;
                  },
                  value: widget.selectedPdv,
                  isExpanded: true,
                  alignment: Alignment.center,
                  hint: Text(snapshot.data == null
                      ? R.string.msgValidateEnterpriseFirst
                      : R.string.selectPdv),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: getStringSize(context),
                      color: Colors.black),
                  items: snapshot.data
                      ?.map(
                        (e) => DropdownMenuItem(
                          value: e,
                          onTap: () async {},
                          child: Center(
                            child: Text(
                                "${R.string.pdv.toUpperCase()} ${e.PdvNumber}"),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    widget.updateSelectedPdv(value);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: ElevatedButton(
                  onPressed: widget.selectedPdv == null
                      ? null
                      : () async {
                          await enterprisePresenter.registerPdvAndGoToHomePage(
                            selectedPdv: widget.selectedPdv!,
                            commandNumber:
                                widget.commandNumberController.text.isEmpty
                                    ? null
                                    : widget.commandNumberController.text,
                            isFixedCommandNumber: widget.isFixedCommandNumber,
                          );
                        },
                  child: Text(
                    widget.selectedPdv == null
                        ? R.string.selectPdv
                        : R.string.register,
                  ),
                ),
              ),
            ],
          );
        });
  }
}
