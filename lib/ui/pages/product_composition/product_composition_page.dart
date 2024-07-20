import 'package:clean_celta_mobile/ui/components/components.dart';
import 'package:provider/provider.dart';

import 'dart:async';
import 'package:flutter/material.dart';

import '../../../ui/helpers/helpers.dart';
import '../../../ui/pages/pages.dart';
import '../../mixins/mixins.dart';

class ProductCompositionPage extends StatefulWidget {
  const ProductCompositionPage({super.key});

  @override
  State<ProductCompositionPage> createState() => _ProductCompositionPageState();
}

class _ProductCompositionPageState extends State<ProductCompositionPage>
    with KeyboardManager, LoadingManager, UIErrorManager {
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
    ProductCompositionPresenter productCompositionPresenter =
        Provider.of(context, listen: false);

    loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();

    loadingSubscription =
        handleLoading(context, productCompositionPresenter.isLoadingStream);
    mainErrorSubscription =
        handleMainError(context, productCompositionPresenter.mainErrorStream);

    return StreamBuilder<ProductsViewModel?>(
        stream: productCompositionPresenter.selectedComboxProductStream,
        builder: (context, snapshot) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                textAlign: TextAlign.center,
                snapshot.data?.Name ?? "",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: hasMinWidth(context) ? 30 : 20,
                  color: Theme.of(context).primaryColorLight,
                ),
              ),
            ),
            body: snapshot.data != null &&
                    snapshot.data?.childsComposition != null
                ? Column(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                  itemCount:
                                      snapshot.data!.childsComposition!.length,
                                  itemBuilder: (context, fatherIndex) {
                                    final father = snapshot
                                        .data!.childsComposition![fatherIndex];
                                    return SizedBox(
                                      height: 60,
                                      child: FittedBox(
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20),
                                              child: SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.2,
                                                child: FittedBox(
                                                  child: Text(
                                                    father.ChildName!
                                                        .toUpperCase(),
                                                    style: TextStyle(
                                                      fontSize: getStringSize(
                                                              context) *
                                                          1.5,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const Divider(),
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                            Expanded(
                              flex: 5,
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount:
                                    snapshot.data!.childsComposition!.length,
                                itemBuilder: (context, fathersIndex) {
                                  final father = snapshot
                                      .data!.childsComposition![fathersIndex];

                                  return Column(
                                    children: [
                                      Row(
                                        children: [
                                          if (father.childs?.isEmpty == true)
                                            Expanded(
                                              child: Center(
                                                child: Text(
                                                  father.ChildName!,
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                          if (father.childs?.isNotEmpty == true)
                                            Expanded(
                                              child: ListView.builder(
                                                shrinkWrap: true,
                                                itemCount:
                                                    father.childs!.length,
                                                itemBuilder:
                                                    (context, childsIndex) {
                                                  final child = father
                                                      .childs![childsIndex];

                                                  return Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            bottom: 5,
                                                            right: 2),
                                                    padding:
                                                        const EdgeInsets.all(8),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      border: Border.all(
                                                          color: const Color
                                                              .fromARGB(255,
                                                              220, 218, 218)),
                                                      boxShadow: const [
                                                        BoxShadow(
                                                          blurRadius: 10,
                                                          color:
                                                              Color(0x33000000),
                                                          offset:
                                                              Offset(-3, -1),
                                                        )
                                                      ],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          flex: 20,
                                                          child: ImageWidget(
                                                            ean: null,
                                                            plu:
                                                                child.PluChild!,
                                                            isAlcoholic: false,
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 80,
                                                          child: Text(
                                                            child.ChildName!,
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Radio<int>(
                                                            value: childsIndex,
                                                            groupValue: father
                                                                .indexOfSelectedChild,
                                                            visualDensity:
                                                                VisualDensity
                                                                    .compact,
                                                            toggleable: father
                                                                    .IsOptionalItem ==
                                                                "true",
                                                            onChanged:
                                                                (int? value) {
                                                              // updateSelectedIndex();
                                                            },
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                        ],
                                      ),
                                      const Divider(),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Expanded(
                      //   child: Composition(
                      //     selectedComboxProduct:
                      //         snapshot.data!,
                      //   ),
                      // ),
                    ],
                  )
                : const Center(child: Text("Deu algum erro")),
          );
        });
  }
}
