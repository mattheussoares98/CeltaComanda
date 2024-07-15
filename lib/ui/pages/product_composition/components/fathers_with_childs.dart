import 'package:flutter/material.dart';

import '../../../components/components.dart';
import '../../pages.dart';

class FathersWithChilds extends StatefulWidget {
  final ProductCompositionViewModel father;
  final List<ProductCompositionViewModel> productsCompositions;
  final int index;
  const FathersWithChilds({
    required this.father,
    required this.productsCompositions,
    required this.index,
    super.key,
  });

  @override
  State<FathersWithChilds> createState() => _FathersWithChildsState();
}

class _FathersWithChildsState extends State<FathersWithChilds> {
  int selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              offset: Offset(2, 2),
              color: Color.fromARGB(255, 209, 208, 208),
              blurRadius: 8,
            ),
            BoxShadow(
              offset: Offset(-2, -2),
              color: Color.fromARGB(255, 209, 208, 208),
              blurRadius: 8,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FixedFatherDetails(
                father: widget.father,
                callSetState: () {
                  setState(() {});
                },
              ),
              if (widget.father.commentFather != null)
                CommentRichText(comment: widget.father.commentFather!),
              ChildsItemsRadioListTile(
                productsCompositionsViewModel: widget.productsCompositions,
                isFixedItemInCombox: widget.father.childs?.isEmpty == true,
                father: widget.father,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
