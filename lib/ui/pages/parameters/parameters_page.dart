import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/models/models.dart';
import '../../helpers/helpers.dart';
import '../../mixins/mixins.dart';
import '../pages.dart';

class ParametersPage extends StatefulWidget {
  const ParametersPage({super.key});

  @override
  State<ParametersPage> createState() => _ParametersPageState();
}

class _ParametersPageState extends State<ParametersPage>
    with LoadingManager, UIErrorManager {
  StreamSubscription? loadingSubscription;
  StreamSubscription? mainErrorSubscription;

  @override
  initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        ParametersPresenter parametersPresenter =
            Provider.of(context, listen: false);

        await parametersPresenter.loadParameters();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    ParametersPresenter parametersPresenter =
        Provider.of(context, listen: false);
    MenuPresenter menuPresenter = Provider.of(context, listen: false);

    loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();

    handleLoading(context, parametersPresenter.isLoadingStream);
    mainErrorSubscription =
        handleMainError(context, parametersPresenter.mainErrorStream);

    return Scaffold(
      appBar: AppBar(
        title: FittedBox(child: Text(R.string.parameters)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<List<ParameterModel>?>(
            stream: parametersPresenter.parametersStream,
            builder: (context, snapshot) {
              if (snapshot.data == null) {
                return const SizedBox();
              }

              return SafeArea(
                child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final parameter = snapshot.data![index];

                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color:
                            Theme.of(context).primaryColorLight.withAlpha(30),
                      ),
                      child: InkWell(
                        onTap: () async {
                          await parametersPresenter.changeParameter(index);
                          await menuPresenter.treatShowSearchProducts();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  parameter.name,
                                  style: TextStyle(
                                    fontSize: StringSize.size,
                                  ),
                                ),
                              ),
                              Switch(
                                value: parameter.enabled,
                                onChanged: (_) async {
                                  await parametersPresenter
                                      .changeParameter(index);
                                  await menuPresenter
                                      .treatShowSearchProducts();
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            }),
      ),
    );
  }
}
