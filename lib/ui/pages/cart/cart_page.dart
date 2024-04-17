import 'package:flutter/material.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 4,
                          color: Color(0x33000000),
                          offset: Offset(
                            0,
                            2,
                          ),
                        )
                      ],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 0, 0, 12),
                            child: ListView(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                      children: [
                                        // ImageWidget(product: product),
                                        // ClipRRect(
                                        //   borderRadius:
                                        //       BorderRadius.circular(12),
                                        //   child: Image.network(
                                        //     "https://www.dotcominfoway.com/wp-content/uploads/2020/01/app-development-platforms.png",
                                        //     width: 70,
                                        //     height: 70,
                                        //     fit: BoxFit.cover,
                                        //   ),
                                        // ),
                                        const Expanded(
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Text(
                                              'TITLE: Men\'s -Shirt Tumbled Grey/F diaos oisah doasih la',
                                            ),
                                          ),
                                        ),
                                        FittedBox(
                                          child: Container(
                                            // padding: const EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colors.grey[300],
                                            ),
                                            child: Row(
                                              children: [
                                                IconButton(
                                                  icon: const Icon(
                                                    Icons.delete,
                                                  ),
                                                  iconSize: 20,
                                                  visualDensity:
                                                      VisualDensity.compact,
                                                  onPressed: () {},
                                                  color:
                                                      const Color(0xFFFF5963),
                                                ),
                                                // SizedBox(width: 5),
                                                const Text("1"),
                                                // SizedBox(width: 5),
                                                IconButton(
                                                  icon: const Icon(
                                                    Icons.add,
                                                  ),
                                                  iconSize: 20,
                                                  visualDensity:
                                                      VisualDensity.compact,
                                                  onPressed: () {},
                                                  color:
                                                      const Color(0xFFFF5963),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 12, 0, 0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Order Summary',
                                ),
                                const Divider(
                                  height: 32,
                                  thickness: 2,
                                  color: Color(0xFFE0E3E7),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 0, 8),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Base Price',
                                          ),
                                          Text(
                                            '\$156.00',
                                            textAlign: TextAlign.end,
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(0, 8, 0, 8),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                const Text(
                                                  'Total',
                                                ),
                                                IconButton(
                                                  icon: const Icon(
                                                    Icons.info_outlined,
                                                    color: Color(0xFF57636C),
                                                    size: 18,
                                                  ),
                                                  onPressed: () {},
                                                ),
                                              ],
                                            ),
                                            const Text(
                                              '\$230.20',
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
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
          Padding(
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 5),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                // fixedSize: const Size(double.infinity, 60),
                minimumSize: const Size(double.infinity, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: const BorderSide(
                    color: Color(0xFFE0E3E7),
                  ),
                ),
              ),
              onPressed: () {},
              child: const Text(
                'Salvar pedido',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
