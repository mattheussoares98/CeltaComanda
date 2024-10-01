import 'package:flutter/material.dart';

import '../../../../presentation/protocols/protocols.dart';
import '../../../../ui/components/components.dart';
import '../../../helpers/helpers.dart';
import '../../pages.dart';

class GetCustomer extends StatelessWidget {
  final TextEditingController textController;
  final CovenantPresenter covenantPresenter;
  const GetCustomer({
    required this.covenantPresenter,
    required this.textController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: StreamBuilder<ValidationError?>(
          stream: covenantPresenter.customerErrorStream,
          builder: (context, snapshot) {
            return Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: formFieldDecoration(
                      context: context,
                      hintText: R.string.customer,
                      labelText: R.string.customer,
                      errorText: snapshot.data?.description,
                      suffixIcon: Icon(Icons.search,
                          color: Theme.of(context).primaryColor),
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: textController,
                    onFieldSubmitted: (_) async {
                      await covenantPresenter.getCustomer(textController.text);
                    },
                    onChanged: (value) => covenantPresenter
                        .validateCustomerField(textController.text),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    await covenantPresenter.getCustomer(textController.text);
                  },
                  child: Text(R.string.getCustomer),
                )
              ],
            );
          }),
    );
  }
}
