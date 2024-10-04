// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/components.dart';
import '../../helpers/helpers.dart';
import '../../mixins/mixins.dart';
import '../pages.dart';

class CovenantPage extends StatefulWidget {
  final CovenantPresenter covenantPresenter;
  const CovenantPage({
    required this.covenantPresenter,
    super.key,
  });

  @override
  State<CovenantPage> createState() => _CovenantPageState();
}

class _CovenantPageState extends State<CovenantPage>
    with LoadingManager, UIErrorManager {
  final textController = TextEditingController();
  StreamSubscription? loadingSubscription;
  StreamSubscription? mainErrorSubscription;

  @override
  void dispose() {
    super.dispose();

    textController.dispose();
    loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();

    loadingSubscription =
        handleLoading(context, widget.covenantPresenter.isLoadingStream);
    mainErrorSubscription =
        handleMainError(context, widget.covenantPresenter.mainErrorStream);

    return PopScope(
      canPop: false,
      child: ListenableProvider(
        create: (_) => widget.covenantPresenter,
        child: Scaffold(
          appBar: AppBar(
            title: Text(R.string.covenant),
            leading: IconButton(
              onPressed: () async {
                bool isPendant = await widget.covenantPresenter
                    .getCovenantAuthorizationIsPendant();

                if (isPendant) {
                  notificationDialog(
                    context: context,
                    titleMessage: "Pendant helper",
                    closeDialogOnConfirmPress: true,
                    content: const Text(
                        "Add helper with message indicating that authorization is pendant"),
                    onPress: () async {
                      Navigator.of(context).pop();
                    },
                  );
                } else {
                  Navigator.of(context).pop();
                }
              },
              icon: const Icon(Icons.arrow_back),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GetCustomer(
                    textController: textController,
                  ),
                  const Customers(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
