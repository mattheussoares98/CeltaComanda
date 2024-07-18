import 'dart:async';
import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../../ui/pages/pages.dart';
import '../../mixins/mixins.dart';

class CommentsPage extends StatefulWidget {
  final String selectedProductName;
  final int productInternalCodeOnERP;
  const CommentsPage({
    super.key,
    required this.selectedProductName,
    required this.productInternalCodeOnERP,
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
              const AddCommentFormField(),
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
            ],
          ),
        ),
      ),
    );
  }
}
