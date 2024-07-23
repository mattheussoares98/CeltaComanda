import 'package:flutter/material.dart';

import '../../../components/components.dart';

class EnterpriseLogoImage extends StatelessWidget {
  const EnterpriseLogoImage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
    );
  }
}