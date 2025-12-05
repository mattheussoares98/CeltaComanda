import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../main/builders/builders.dart';
import '../../components/components.dart';
import '../../helpers/helpers.dart';
import '../pages.dart';

class WebSaleRequestDetailsValidateEnterprisePage extends StatefulWidget {
  const WebSaleRequestDetailsValidateEnterprisePage({super.key});

  @override
  State<WebSaleRequestDetailsValidateEnterprisePage> createState() =>
      _WebSaleRequestDetailsValidateEnterprisePageState();
}

class _WebSaleRequestDetailsValidateEnterprisePageState
    extends State<WebSaleRequestDetailsValidateEnterprisePage> {
  final controller = TextEditingController();
  bool isLoading = false;

  @override
  dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        if (EnterpriseBuilder.entity?.enterpriseName != null &&
            EnterpriseBuilder.entity!.enterpriseName.isNotEmpty) {
          controller.text = EnterpriseBuilder.entity!.enterpriseName;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider =
        Provider.of<WebSaleRequestDetailsPresenter>(context, listen: false);

    return Stack(
      children: [
        Scaffold(
            body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: controller,
                onFieldSubmitted: (_) =>
                    provider.validateEnterprise(controller.text),
                decoration: formFieldDecoration(
                  context: context,
                  hintText: R.string.enterprise,
                  labelText: R.string.enterprise,
                  errorText: null,
                ),
              ),
              const SizedBox(
                height: 32,
              ),
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    isLoading = true;
                  });
                  await provider.validateEnterprise(controller.text);
                  setState(() {
                    isLoading = false;
                  });
                },
                child: Text(R.string.validateEnterprise),
              )
            ],
          ),
        )),
        if (isLoading)
          Scaffold(
            backgroundColor: Colors.grey[200],
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          )
      ],
    );
  }
}
