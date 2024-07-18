import 'dart:async';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../../ui/helpers/helpers.dart';
import '../../../ui/pages/pages.dart';
import '../../mixins/mixins.dart';

class CommentsPage extends StatefulWidget {
  final String selectedProductName;
  final int productInternalCodeOnERP;
  final Future Function()? doOnClickInConfirmButton;
  const CommentsPage({
    super.key,
    required this.selectedProductName,
    required this.productInternalCodeOnERP,
    this.doOnClickInConfirmButton,
  });

  @override
  State<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage>
    with KeyboardManager, LoadingManager, UIErrorManager {
  final commentsController = TextEditingController();

  StreamSubscription? loadingSubscription;
  StreamSubscription? mainErrorSubscription;

  @override
  void dispose() {
    super.dispose();
    loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    CommentsPresenter commentsPresenter = Provider.of(context);

    loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();
    loadingSubscription =
        handleLoading(context, commentsPresenter.isLoadingStream);
    mainErrorSubscription =
        handleMainError(context, commentsPresenter.mainErrorStream);

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 15, 8, 0),
          child: Column(
            children: [
              TitlePage(
                selectedProductName: widget.selectedProductName,
              ),
              const SizedBox(height: 15),
              const SizedBox(height: 8),
              if (commentsPresenter.loadedComments
                  .where((e) =>
                      e.ProductInternalCodeOnErp.toInt() ==
                          widget.productInternalCodeOnERP &&
                      e.ProductName == widget.selectedProductName)
                  .isNotEmpty)
                CommentsList(
                  productInternalCodeOnERP: widget.productInternalCodeOnERP,
                  selectedProductName: widget.selectedProductName,
                ),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    Future.delayed(Duration.zero, () {
                      Navigator.of(context)
                          .popUntil((route) => route.isFirst);
                    });
    
                    if (widget.doOnClickInConfirmButton != null) {
                      await widget.doOnClickInConfirmButton!();
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.shopping_cart),
                      const SizedBox(width: 20),
                      FittedBox(
                        child: Text(
                          "Confirmar",
                          style: TextStyle(
                            fontSize: getStringSize(context),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
