import 'package:flutter/material.dart';

import '../../../components/components.dart';

class SearchCommandField extends StatefulWidget {
  final TextEditingController commandNumberController;
  final Future<void> Function() searchData;
  const SearchCommandField({
    required this.commandNumberController,
    required this.searchData,
    super.key,
  });

  @override
  State<SearchCommandField> createState() => _SearchCommandFieldState();
}

class _SearchCommandFieldState extends State<SearchCommandField> {
  final _formKey = GlobalKey<FormState>();
  final focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: CommandField(
        commandNumberController: widget.commandNumberController,
        focusNode: focusNode,
        loadData: () async {
          bool? isValid = _formKey.currentState?.validate();
      
          if (isValid == true) {
            await widget.searchData();
            focusNode.unfocus();
          }
        },
      ),
    );
  }
}
