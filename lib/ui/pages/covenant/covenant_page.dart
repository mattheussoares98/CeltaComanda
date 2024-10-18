import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../presentation/protocols/protocols.dart';
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
  int? _selectedOption = 0;

  @override
  void dispose() async {
    super.dispose();

    textController.dispose();
    loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();
    await widget.covenantPresenter.updateSelectedCovenant(null, "");
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        await widget.covenantPresenter.updateSelectedCovenant(null, "");
      }
    });
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
            leading: const PersonalizedLeadingAppbar(),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: StreamBuilder<ValidationError?>(
                      stream: widget.covenantPresenter.customerErrorStream,
                      builder: (context, snapshot) {
                        return Column(
                          children: [
                            GetCustomerField(
                              textController: textController,
                              errorText: snapshot.data?.description,
                              searchByPersonalizedCode: _selectedOption == 1,
                            ),
                            SearchTypeRadios(
                              updateSelectedOption: (value) {
                                setState(() {
                                  _selectedOption = value;
                                });
                              },
                              selectedOption: _selectedOption,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  Customers(textController: textController),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
