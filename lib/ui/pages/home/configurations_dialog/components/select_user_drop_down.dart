import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../helpers/helpers.dart';
import '../../../pages.dart';

class SelectUserDropDown extends StatelessWidget {
  final UserConcentratorViewModel? selectedUser;
  final void Function(UserConcentratorViewModel? user) updateSelectedUser;
  const SelectUserDropDown({
    super.key,
    required this.selectedUser,
    required this.updateSelectedUser,
  });

  @override
  Widget build(BuildContext context) {
    ConfigurationsPresenter configurationsPresenter =
        Provider.of(context, listen: false);

    return DropdownButtonFormField<UserConcentratorViewModel>(
      validator: (value) {
        if (selectedUser == null) {
          return R.string.selectUser;
        }
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
              onTap: () {},
              child: Center(
                child: Text(e.Name.toString()),
              ),
            ),
          )
          .toList(),
      onChanged: updateSelectedUser,
    );
  }
}
