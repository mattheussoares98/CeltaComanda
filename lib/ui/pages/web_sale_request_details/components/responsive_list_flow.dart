import 'dart:math';

import 'package:flutter/widgets.dart';

class ResponsiveListFlow extends StatelessWidget {
  final int itemCount;
  final Widget Function(BuildContext context, int index) itemBuilder;
  final double? maxItemWidth;
  final bool shrinkWrap;
  const ResponsiveListFlow({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.maxItemWidth = 450,
    this.shrinkWrap = false,
  });

  @override
  Widget build(BuildContext context) {
    // if (isSliver) {
    //   return SliverLayoutBuilder(
    //     builder: (context, constraints) {
    //       final itemsPerRow = max(
    //         (constraints.crossAxisExtent / maxItemWidth!).floor(),
    //         1,
    //       );
    //       final rowCount = (itemCount / itemsPerRow).ceil();

    //       return SliverList.builder(
    //         itemCount: rowCount,
    //         itemBuilder: (context, rowIndex) {
    //           return _RowsItems(
    //             itemCount: itemCount,
    //             itemBuilder: itemBuilder,
    //             itemsPerRow: itemsPerRow,
    //             rowIndex: rowIndex,
    //           );
    //         },
    //       );
    //     },
    //   );
    // }

    return LayoutBuilder(
      builder: (context, constraints) {
        final int columnsCount = max(
          (constraints.maxWidth / maxItemWidth!).floor(),
          1,
        );

        // 2. Distribute indices into columns (e.g., Column 0, Column 1)
        final List<List<int>> columns = List.generate(columnsCount, (_) => []);
        for (int i = 0; i < itemCount; i++) {
          columns[i % columnsCount].add(i);
        }

        // 3. Render a Row of Columns
        Widget content = Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(columnsCount, (colIndex) {
            return Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: columns[colIndex].map((index) {
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: itemBuilder(context, index),
                  );
                }).toList(),
              ),
            );
          }),
        );

        // 4. Wrap in ScrollView if it's not a Sliver
        return shrinkWrap ? content : SingleChildScrollView(child: content);
      },
    );
  }
}
