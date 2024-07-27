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
  @override
  Widget build(BuildContext context) {
    ProductCompositionPresenter productCompositionPresenter =
        Provider.of(context, listen: false);

    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    productCompositionPresenter.updateComboxQuantity(false);
                  });
                },
                child: CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColorLight,
                  child: const Icon(Icons.remove),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColorDark,
                  radius: 40,
                  child: FittedBox(
                    child: Text(
                      productCompositionPresenter.totalComboxQuantity
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
              InkWell(
                onTap: () {
                  setState(() {
                    productCompositionPresenter.updateComboxQuantity(true);
                  });
                },
                child: CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColorLight,
                  child: const Icon(Icons.add),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
