import 'package:flutter/material.dart';

import '../../../components/components.dart';
import '../../../helpers/helpers.dart';

class SearchCommandField extends StatelessWidget {
  final TextEditingController commandNumberController;
  final Future<void> Function() searchData;
  const SearchCommandField({
    required this.commandNumberController,
    required this.searchData,
    super.key,
  });

  static final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: CommandField(
              commandNumberController: commandNumberController,
            ),
          ),
          IconButton(
            onPressed: () async {
              bool? isValid = _formKey.currentState?.validate();

              if (isValid == true) {
                await searchData();
              }
            },
            icon: Row(
              children: [
                Icon(Icons.refresh),
                if (hasMinWidth(context))
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text(R.string.search),
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
