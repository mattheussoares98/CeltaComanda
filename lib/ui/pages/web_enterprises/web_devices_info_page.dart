import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../helpers/helpers.dart';
import '../pages.dart';
import 'web_devices_info_components/web_devices_info_components.dart';

class WebDevicesInfoPage extends StatefulWidget {
  const WebDevicesInfoPage({super.key});

  @override
  State<WebDevicesInfoPage> createState() => _WebDevicesInfoPageState();
}

class _WebDevicesInfoPageState extends State<WebDevicesInfoPage> {
  bool isAscending = false;
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

  void sortCommand(List<DeviceInfoViewModel>? data) {
    setState(() {
      if (isAscending) {
        data!.sort((a, b) =>
            a.commandNumber.toInt().compareTo(b.commandNumber.toInt()));
      } else {
        data!.sort((a, b) =>
            b.commandNumber.toInt().compareTo(a.commandNumber.toInt()));
      }
      isAscending = !isAscending;
    });
  }

  void sortAppVersion(List<DeviceInfoViewModel>? data) {
    setState(() {
      if (isAscending) {
        data!.sort(
            (a, b) => a.applicationVersion.compareTo(b.applicationVersion));
      } else {
        data!.sort(
            (a, b) => b.applicationVersion.compareTo(a.applicationVersion));
      }
      isAscending = !isAscending;
    });
  }

  void sortVersionDate(List<DeviceInfoViewModel>? data) {
    final format = DateFormat("dd/MM/yyyy HH:mm:ss");

    setState(() {
      if (isAscending) {
        data!.sort((a, b) => format
            .parse(a.lastUpdatedDate)
            .compareTo(format.parse(b.lastUpdatedDate)));
      } else {
        data!.sort((a, b) => format
            .parse(b.lastUpdatedDate)
            .compareTo(format.parse(a.lastUpdatedDate)));
      }
      isAscending = !isAscending;
    });
  }

  void sortPdvNumber(List<DeviceInfoViewModel>? data) {
    setState(() {
      if (isAscending) {
        data!.sort((a, b) => a.pdvNumber
            .toString()
            .toInt()
            .compareTo(b.pdvNumber.toString().toInt()));
      } else {
        data!.sort((a, b) => b.pdvNumber
            .toString()
            .toInt()
            .compareTo(a.pdvNumber.toString().toInt()));
      }
      isAscending = !isAscending;
    });
  }

  @override
  Widget build(BuildContext context) {
    WebEnterprisesPresenter webEnterprisesPresenter =
        Provider.of(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: FittedBox(child: Text(R.string.devicesInformations)),
        actions: [
          IconButton(
            onPressed: () async {
              await webEnterprisesPresenter.getDevicesInfo();
            },
            icon: Icon(Icons.refresh, color: Theme.of(context).primaryColor),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: StreamBuilder<List<DeviceInfoViewModel>?>(
          stream: webEnterprisesPresenter.devicesStream,
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: TextButton.icon(
                        onPressed: () async {
                          await webEnterprisesPresenter.getDevicesInfo();
                        },
                        label: Text(
                          R.string.reload,
                          style: TextStyle(fontSize: StringSize.size),
                        ),
                        icon: const Icon(Icons.refresh, size: 25),
                        iconAlignment: IconAlignment.end,
                      ),
                    ),
                  ],
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length + 1,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Row(
                          children: [
                            TitleItem(
                              data: snapshot.data!,
                              sort: sortCommand,
                              title: R.string.command,
                            ),
                            TitleItem(
                              data: snapshot.data!,
                              sort: sortCommand,
                              title: R.string.id,
                            ),
                            TitleItem(
                              sort: sortAppVersion,
                              title: R.string.version,
                              data: snapshot.data!,
                            ),
                            TitleItem(
                              sort: sortPdvNumber,
                              title: R.string.pdv,
                              data: snapshot.data!,
                            ),
                            TitleItem(
                              sort: sortVersionDate,
                              title: R.string.lastUpdate,
                              data: snapshot.data!,
                            ),
                          ],
                        );
                      }

                      final DeviceInfoViewModel device =
                          snapshot.data![index - 1];

                      return Container(
                        margin: const EdgeInsets.only(bottom: 5),
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color:
                              Theme.of(context).primaryColorLight.withAlpha(20),
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Center(child: Text(device.commandNumber)),
                            ),
                            Expanded(
                              child:
                                  Center(child: Text(device.imeiOrWindowsId)),
                            ),
                            Expanded(
                              child: Center(
                                  child: Text(device.applicationVersion)),
                            ),
                            Expanded(
                              child:
                                  Center(child: Text(device.pdvNumber ?? "")),
                            ),
                            Expanded(
                              child:
                                  Center(child: Text(device.lastUpdatedDate)),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
