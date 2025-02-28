import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../main/builders/builders.dart';
import '../../../components/components.dart';
import '../../../helpers/helpers.dart';
import '../../pages.dart';

class ChangeComment extends StatelessWidget {
  final int productIndex;
  final int? childIndex;
  final bool showTextFormField;
  final void Function() updateSelectedIndex;
  final TextEditingController controller;
  final void Function() callSetState;
  final FocusNode focusNode;
  const ChangeComment({
    required this.productIndex,
    required this.childIndex,
    required this.showTextFormField,
    required this.updateSelectedIndex,
    required this.controller,
    required this.callSetState,
    required this.focusNode,
    super.key,
  });

  Future<void> changeComment(CartPresenter cartPresenter) async {
    if (controller.text.isEmpty) return;
    await cartPresenter.changeComment(
      comment: controller.text,
      productIndex: productIndex,
      childIndex: childIndex,
    );
    callSetState();
  }

  @override
  Widget build(BuildContext context) {
    CartPresenter cartPresenter = Provider.of(context, listen: false);

    if (EnterpriseBuilder.entity?.canInsertCommentManually != true) {
      return Container();
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: TextButton.icon(
            onPressed: updateSelectedIndex,
            icon: Icon(
              Icons.edit,
              color: Theme.of(context).primaryColor,
            ),
            label: Text(R.string.comment),
          ),
        ),
        if (showTextFormField)
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: TextFormField(
                  focusNode: focusNode,
                  controller: controller,
                  onFieldSubmitted: (value) async {
                    changeComment(cartPresenter);
                  },
                  decoration: formFieldDecoration(
                    context: context,
                    hintText: R.string.comment,
                    labelText: R.string.comment,
                    errorText: null,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  changeComment(cartPresenter);
                },
                child: Text(
                  R.string.confirm,
                ),
              ),
            ],
          ),
      ],
    );
  }
}
