// import 'package:flutter/material.dart';

// void main() {
//   runApp(MyApp());
// }

// class ExpansibleGroupsViewModel {
//   final String groupName;
//   ExpansibleGroupsViewModel(this.groupName);
// }

// class ProductsViewModel {
//   final String productName;
//   final String groupName;
//   double? itemHeight;
//   ProductsViewModel(this.productName, this.groupName);
// }

// class MyApp extends StatefulWidget {
//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   final List<Map<ExpansibleGroupsViewModel, List<ProductsViewModel>>> data = [
//     {
//       ExpansibleGroupsViewModel('Group 1'): [
//         ProductsViewModel('Product 1.1', 'Group 1'),
//         ProductsViewModel('Product 1.2', 'Group 1'),
//         ProductsViewModel('Product 1.3', 'Group 1'),
//         ProductsViewModel('Product 1.4', 'Group 1'),
//         ProductsViewModel('Product 1.5', 'Group 1'),
//         ProductsViewModel('Product 1.6', 'Group 1'),
//         ProductsViewModel('Product 1.7', 'Group 1'),
//         ProductsViewModel('Product 1.8', 'Group 1'),
//         ProductsViewModel('Product 1.9', 'Group 1'),
//         ProductsViewModel('Product 1.11', 'Group 1'),
//         ProductsViewModel('Product 1.12', 'Group 1'),
//         ProductsViewModel('Product 1.13', 'Group 1'),
//         ProductsViewModel('Product 1.14', 'Group 1'),
//         ProductsViewModel('Product 1.15', 'Group 1'),
//         ProductsViewModel('Product 1.16', 'Group 1'),
//         ProductsViewModel('Product 1.17', 'Group 1'),
//         ProductsViewModel('Product 1.18', 'Group 1'),
//         ProductsViewModel('Product 1.19', 'Group 1'),
//         ProductsViewModel('Product 1.20', 'Group 1'),
//         ProductsViewModel('Product 1.21', 'Group 1'),
//       ],
//     },
//     {
//       ExpansibleGroupsViewModel('Group 2'): [
//         ProductsViewModel('Product 2.1', 'Group 2'),
//         ProductsViewModel('Product 2.2', 'Group 2'),
//         ProductsViewModel('Product 2.3', 'Group 2'),
//         ProductsViewModel('Product 2.4', 'Group 2'),
//         ProductsViewModel('Product 2.5', 'Group 2'),
//         ProductsViewModel('Product 2.6', 'Group 2'),
//         ProductsViewModel('Product 2.7', 'Group 2'),
//         ProductsViewModel('Product 2.8', 'Group 2'),
//         ProductsViewModel('Product 2.9', 'Group 2'),
//         ProductsViewModel('Product 2.1', 'Group 2'),
//         ProductsViewModel('Product 2.1', 'Group 2'),
//         ProductsViewModel('Product 2.1', 'Group 2'),
//         ProductsViewModel('Product 2.1', 'Group 2'),
//         ProductsViewModel('Product 2.1', 'Group 2'),
//         ProductsViewModel('Product 2.1', 'Group 2'),
//         ProductsViewModel('Product 2.1', 'Group 2'),
//         ProductsViewModel('Product 2.1', 'Group 2'),
//         ProductsViewModel('Product 2.1', 'Group 2'),
//         ProductsViewModel('Product 2.2', 'Group 2'),
//         ProductsViewModel('Product 2.2', 'Group 2'),
//       ],
//     },
//     {
//       ExpansibleGroupsViewModel('Group 3'): [
//         ProductsViewModel('Product 3.1', 'Group 3'),
//         ProductsViewModel('Product 3.2', 'Group 3'),
//         ProductsViewModel('Product 3.3', 'Group 3'),
//         ProductsViewModel('Product 3.4', 'Group 3'),
//         ProductsViewModel('Product 3.5', 'Group 3'),
//         ProductsViewModel('Product 3.6', 'Group 3'),
//         ProductsViewModel('Product 3.7', 'Group 3'),
//         ProductsViewModel('Product 3.8', 'Group 3'),
//         ProductsViewModel('Product 3.9', 'Group 3'),
//         ProductsViewModel('Product 3.11', 'Group 3'),
//         ProductsViewModel('Product 3.12', 'Group 3'),
//         ProductsViewModel('Product 3.13', 'Group 3'),
//         ProductsViewModel('Product 3.14', 'Group 3'),
//         ProductsViewModel('Product 3.15', 'Group 3'),
//         ProductsViewModel('Product 3.16', 'Group 3'),
//         ProductsViewModel('Product 3.17', 'Group 3'),
//         ProductsViewModel('Product 3.18', 'Group 3'),
//         ProductsViewModel('Product 3.19', 'Group 3'),
//         ProductsViewModel('Product 3.2', 'Group 3'),
//         ProductsViewModel('Product 3.21', 'Group 3'),
//       ],
//     },
//   ];

//   // Crie um mapa para associar produtos aos grupos
//   final Map<ProductsViewModel, ExpansibleGroupsViewModel> productToGroup = {};

//   // Crie um ScrollController para controlar a posição da lista de produtos
//   final ScrollController _scrollController = ScrollController();

//   void scrollToGroup(ExpansibleGroupsViewModel group, List allProducts) {
//     // Encontre o primeiro produto desse grupo
//     final firstProduct = data
//         .firstWhere(
//             (groupData) => groupData.keys.first.groupName == group.groupName)
//         .values
//         .first
//         .first;

//     // Role até a posição do primeiro produto desse grupo
//     _scrollController.animateTo(
//       allProducts.indexOf(firstProduct) *
//           (firstProduct.itemHeight ??
//               50), // Substitua itemHeight pelo tamanho real do item
//       duration: const Duration(milliseconds: 500),
//       curve: Curves.easeInOut,
//     );
//   }

//   final Map<int, double> _itemHeights = {};
//   final List<ProductsViewModel> allProducts = [];

//   @override
//   void initState() {
//     super.initState();
//     for (var x in data) {
//       for (var product in x.values) {
//         allProducts.addAll(product);
//       }
//     }
//    getItemsHeight();
//   }

//   Future<void> getItemsHeight() async {
//     await Future.delayed(const Duration(milliseconds: 300), () {});
//     _scrollController.animateTo(
//       _scrollController.position
//           .maxScrollExtent, // Substitua itemHeight pelo tamanho real do item
//       duration: const Duration(milliseconds: 300),
//       curve: Curves.easeInOut,
//     );
//     await Future.delayed(const Duration(milliseconds: 300), () {
//       _scrollController.animateTo(
//         0, // Substitua itemHeight pelo tamanho real do item
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeInOut,
//       );
//     });
//   }

//   @override
//   void didChangeDependencies() async {
//     super.didChangeDependencies();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(title: const Text('Groups and Products')),
//         body: Row(
//           children: [
//             Expanded(
//               flex: 1,
//               child: ListView(
//                 children: data.map((groupData) {
//                   final group = groupData.keys.first;
//                   return GestureDetector(
//                     onTap: () {
//                       // Quando o usuário clicar no grupo, role até os produtos correspondentes
//                       scrollToGroup(group, allProducts);
//                     },
//                     child: Container(
//                       padding: EdgeInsets.all(10),
//                       child: Text(group.groupName),
//                     ),
//                   );
//                 }).toList(),
//               ),
//             ),
//             Expanded(
//               flex: 3,
//               child: ListView.builder(
//                 controller: _scrollController,
//                 itemCount: allProducts.length,
//                 itemBuilder: (context, index) {
//                   final product = allProducts[index];
//                   return KeyedSubtree(
//                     key: ValueKey(index),
//                     child: Builder(
//                       builder: (BuildContext context) {
//                         WidgetsBinding.instance.addPostFrameCallback((_) {
//                           final RenderBox itemBox =
//                               context.findRenderObject() as RenderBox;
//                           _itemHeights[index] = itemBox.size.height;
//                           product.itemHeight = itemBox.size.height;
//                         });
//                         return ListTile(
//                           title: Text(product.productName),
//                           subtitle: Text(product.itemHeight.toString()),
//                         );
//                       },
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class GroupHeaderDelegate extends SliverPersistentHeaderDelegate {
//   final String groupName;
//   final VoidCallback onTap;

//   GroupHeaderDelegate(this.groupName, this.onTap);

//   @override
//   Widget build(
//       BuildContext context, double shrinkOffset, bool overlapsContent) {
//     // Construir o cabeçalho persistente
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         // Configurações do cabeçalho
//         // ...
//         child: Text(groupName),
//       ),
//     );
//   }

//   @override
//   // TODO: implement maxExtent
//   double get maxExtent => 100;

//   @override
//   // TODO: implement minExtent
//   double get minExtent => 30;

//   @override
//   bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
//     // TODO: implement shouldRebuild
//     throw UnimplementedError();
//   }

//   // Restante do código do GroupHeaderDelegate...
// }
