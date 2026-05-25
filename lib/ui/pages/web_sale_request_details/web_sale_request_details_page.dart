import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../domain/entities/entities.dart';
import '../../helpers/helpers.dart';
import '../../mixins/mixins.dart';
import '../pages.dart';
import 'components/components.dart';

class WebSaleRequestDetailsPage extends StatefulWidget {
  const WebSaleRequestDetailsPage({super.key});

  @override
  State<WebSaleRequestDetailsPage> createState() =>
      _WebSaleRequestDetailsPageState();
}

class _WebSaleRequestDetailsPageState extends State<WebSaleRequestDetailsPage>
    with UIErrorManager {
  Timer? _dataRefreshTimer;
  StreamSubscription? mainErrorSubscription;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        _dataRefreshTimer = Timer.periodic(
          const Duration(seconds: 30),
          (timer) {
            _fetchAndUpdateData();
          },
        );

        _fetchAndUpdateData();
      }
    });
  }

  @override
  void dispose() {
    _dataRefreshTimer?.cancel();
    mainErrorSubscription?.cancel();
    super.dispose();
  }

  void _fetchAndUpdateData() {
    final provider =
        Provider.of<WebSaleRequestDetailsPresenter>(context, listen: false);
    provider.loadDeliveryControls();
  }

  @override
  Widget build(BuildContext context) {
    final provider =
        Provider.of<WebSaleRequestDetailsPresenter>(context, listen: false);
    mainErrorSubscription = handleMainError(context, provider.mainErrorStream);

    return Scaffold(
      body: StreamBuilder(
        stream: provider.deliveryControlsStream,
        builder: (context, snapshot) {
          if (snapshot.hasData == false || (snapshot.data?.isEmpty ?? true)) {
            return Center(
              child: Text(R.string.emptySaleRequests),
            );
          }

          return Row(
            children: [
              Expanded(
                child: RequestsItems(
                  isToDeliveryStatus: IsToDelivery.preparing,
                  deliveryControls: List.of(snapshot.data!),
                ),
              ),
              Expanded(
                child: RequestsItems(
                  isToDeliveryStatus: IsToDelivery.ready,
                  deliveryControls: List.of(snapshot.data!),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
