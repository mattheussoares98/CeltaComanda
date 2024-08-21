import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../helpers/helpers.dart';
import '../../../pages.dart';

class UpdateSellerDropdown extends StatelessWidget {
  final bool isUpdatingSeller;
  final Function(SellersViewModel? value) updateSelectedSeller;
  const UpdateSellerDropdown({
    required this.isUpdatingSeller,
    required this.updateSelectedSeller,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    HomePresenter homePresenter = Provider.of(context, listen: false);

    return DropdownButtonFormField<SellersViewModel>(
      // value: homePresenter.peoples,
      validator: (value) {
        if (!isUpdatingSeller) {
          return null;
        } else if (value == null) {
          return R.string.msgSelectSeller;
        }

        return null;
      },
      decoration: InputDecoration(
        hintText: R.string.seller,
        labelText: R.string.seller,
      ),
      items: homePresenter.sellers
          .map((e) => DropdownMenuItem(
                value: e,
                onTap: () {
                  updateSelectedSeller(e);
                },
                child: Text(
                  e.Name.toString(),
                ),
              ))
          .toList(),

      onChanged: (value) {
        updateSelectedSeller(value);
      },
    );
  }
}
