import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../helpers/helpers.dart';
import '../../../pages.dart';

class SelectUserDropDown extends StatelessWidget {
  final FocusNode passwordFocusNode;
  final FocusNode userNameFocusNode;
  final TextEditingController userNameController;
  const SelectUserDropDown({
    super.key,
    required this.passwordFocusNode,
    required this.userNameFocusNode,
    required this.userNameController,
  });

  @override
  Widget build(BuildContext context) {
    ConfigurationsPresenter configurationsPresenter =
        Provider.of(context, listen: false);

    return DropdownButtonFormField<UserConcentratorViewModel>(
      validator: (value) {
        return null;
      },
      isExpanded: true,
      alignment: Alignment.center,
      hint: Text(R.string.selectUser),
      style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: StringSize.size,
          color: Colors.black),
      items: configurationsPresenter.loadedUsers
          ?.map(
            (e) => DropdownMenuItem(
              value: e,
              onTap: () async {},
              child: Center(
                child: Text(e.Name.toString()),
              ),
            ),
          )
          .toList(),
      onChanged: (value) async {},
    );
  }
}
