import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../helpers/helpers.dart';
import '../../../pages.dart';

class UpdateSellerDropdown extends StatelessWidget {
  const UpdateSellerDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    HomePresenter homePresenter = Provider.of(context, listen: false);

    return DropdownButtonFormField<SellersViewModel>(
      isExpanded: true,
      initialValue: homePresenter.selectedSeller,
      decoration: InputDecoration(
        hintText: R.string.seller,
        labelText: R.string.seller,
      ),
      items: homePresenter.sellers
          .map((e) => DropdownMenuItem(
                value: e,
                onTap: () {
                  homePresenter.updateSelectedSeller(e);
                },
                child: Text(
                  e.Name.toString(),
                ),
              ))
          .toList(),
      onChanged: (value) {
        homePresenter.updateSelectedSeller(value);
      },
    );
  }
}
