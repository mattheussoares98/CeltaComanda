import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../domain/entities/entities.dart';
import '../../../helpers/helpers.dart';
import '../../pages.dart';

class Enterprises extends StatelessWidget {
  const Enterprises({super.key});

  @override
  Widget build(BuildContext context) {
    WebEnterprisesPresenter webEnterprisesPresenter =
        Provider.of(context, listen: false);

    return StreamBuilder<List<EnterpriseEntity>?>(
        stream: webEnterprisesPresenter.enterprisesStream,
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Center(
              child: TextButton(
                onPressed: () async {
                  await webEnterprisesPresenter.loadEnterprises();
                },
                child: Text(R.string.search),
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final enterprise = snapshot.data![index];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: InkWell(
                    onTap: () {
                      webEnterprisesPresenter
                          .goToAddOrEditEnterprise(enterprise);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: index % 2 == 0
                            ? Theme.of(context).primaryColorLight.withAlpha(30)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(width: 0.2),
                      ),
                      child: Row(
                        children: [
                          Expanded(child: Text(enterprise.enterpriseName)),
                          Icon(
                            Icons.edit,
                            color: Theme.of(context).secondaryHeaderColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        });
  }
}
