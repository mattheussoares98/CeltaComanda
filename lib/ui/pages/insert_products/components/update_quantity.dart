import 'package:clean_celta_mobile/ui/helpers/convert/convert.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../pages.dart';

class UpdateQuantity extends StatefulWidget {
  const UpdateQuantity({super.key});

  @override
  State<UpdateQuantity> createState() => _UpdateQuantityState();
}

class _UpdateQuantityState extends State<UpdateQuantity> {
  Widget getCircleAvatar({
    required InsertProductPresenter insertProductPresenter,
    required bool isAddingQuantity,
  }) {
    return Flexible(
      child: InkWell(
        onTap: () {
          setState(() {
            insertProductPresenter
                .updateTotalProductsQuantity(isAddingQuantity);
          });
        },
        child: CircleAvatar(
          maxRadius: 40,
          backgroundColor: Theme.of(context).primaryColorLight,
          child: Icon(isAddingQuantity ? Icons.add : Icons.remove),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    InsertProductPresenter insertProductPresenter =
        Provider.of(context, listen: false);

    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          getCircleAvatar(
            insertProductPresenter: insertProductPresenter,
            isAddingQuantity: false,
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: CircleAvatar(
                backgroundColor: Theme.of(context).primaryColorDark,
                radius: 70,
                child: FittedBox(
                  child: Text(
                    insertProductPresenter.totalProductsQuantity
                        .toString()
                        .toBrazilianNumber(0),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 50,
                    ),
                  ),
                ),
              ),
            ),
          ),
          getCircleAvatar(
            insertProductPresenter: insertProductPresenter,
            isAddingQuantity: true,
          ),
        ],
      ),
    );
  }
}
