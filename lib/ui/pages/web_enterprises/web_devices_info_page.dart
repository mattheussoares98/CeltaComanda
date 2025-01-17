import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../helpers/helpers.dart';
import '../pages.dart';

class WebDevicesInfoPage extends StatefulWidget {
  const WebDevicesInfoPage({super.key});

  @override
  State<WebDevicesInfoPage> createState() => _WebDevicesInfoPageState();
}

class _WebDevicesInfoPageState extends State<WebDevicesInfoPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        await Provider.of<WebEnterprisesPresenter>(context, listen: false)
            .getDevicesInfo();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    WebEnterprisesPresenter webEnterprisesPresenter =
        Provider.of(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(R.string.devicesInformations),
        actions: [
          IconButton(
            onPressed: () async {
              await webEnterprisesPresenter.getDevicesInfo();
            },
            icon: Icon(Icons.refresh, color: Theme.of(context).primaryColor),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: webEnterprisesPresenter.devicesStream,
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Center(
              child: Text(R.string.msgNotFound),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final device = snapshot.data![index];

              return Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColorLight.withAlpha(30),
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Text(device.commandNumber),
                    Text(device.applicationVersion),
                    Text(device.imeiOrWindowsId),
                    Text(device.lastUpdatedDate),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
