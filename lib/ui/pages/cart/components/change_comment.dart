import 'package:flutter/material.dart';

import '../../../components/components.dart';
import '../../../helpers/helpers.dart';

class ChangeComment extends StatefulWidget {
  final int index;
  final int? selectedIndex;
  final void Function() updateSelectedIndex;
  const ChangeComment({
    required this.index,
    required this.selectedIndex,
    required this.updateSelectedIndex,
    super.key,
  });

  @override
  State<ChangeComment> createState() => _ChangeCommentState();
}

class _ChangeCommentState extends State<ChangeComment> {
  final controller = TextEditingController();

  @override
  void dispose() {
    super.dispose();

    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: TextButton.icon(
            onPressed: widget.updateSelectedIndex,
            icon: Icon(
              Icons.edit,
              color: Theme.of(context).primaryColor,
            ),
            label: Text(R.string.comment),
          ),
        ),
        if (widget.index == widget.selectedIndex)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: TextFormField(
              controller: controller,
              decoration: formFieldDecoration(
                context: context,
                hintText: R.string.comment,
                labelText: R.string.comment,
                errorText: null,
              ),
            ),
          ),
      ],
    );
  }
}
