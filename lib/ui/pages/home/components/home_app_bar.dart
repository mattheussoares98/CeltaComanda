import 'package:flutter/material.dart';

import '../../../components/components.dart';
import '../../pages.dart';
import 'components.dart';

PreferredSize homeAppBar({
  required HomePresenter homePresenter,
  required BuildContext context,
  required GlobalKey<ScaffoldState> scaffoldKey,
}) {
  return PreferredSize(
    preferredSize: const Size.fromHeight(40),
    child: AppBar(
      title: TitleAppbar(openDrawer: () {
        scaffoldKey.currentState?.openDrawer();
      }),
      leading: FittedBox(
        child: Row(
          children: [
            if (homePresenter.isFixedCommandNumber != true)
              IconButton(
                icon: Icon(
                  Icons.exit_to_app,
                  color: Theme.of(context).primaryColor,
                ),
                onPressed: () {
                  scaffoldKey.currentState?.openDrawer();
                },
              ),
            GestureDetector(
              onTap: () {
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: const CircleAvatar(
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white,
                              child: Icon(
                                Icons.close,
                                size: 40,
                              ),
                            ),
                          ),
                          Flexible(
                            child: AlertDialog(
                              alignment: Alignment.topCenter,
                              insetPadding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 10),
                              content: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: ImageWidget(
                                        ean: null,
                                        plu: "null",
                                        height:
                                            MediaQuery.of(context).size.height,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        isAlcoholic: false,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    });
              },
              child: SizedBox(
                height: AppBar().preferredSize.height,
                width: AppBar().preferredSize.height,
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: ImageWidget(
                    ean: null,
                    plu: "null",
                    isAlcoholic: false,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: const Color(0xFFF1F5F8),
    ),
  );
}
