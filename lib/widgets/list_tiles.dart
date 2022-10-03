import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './tile_item.dart';
import '../providers/Products.dart';

class ListTiles extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context).items;

    return ListView.builder(
      itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
        value: productData[index],
        child: Card(
            elevation: 4,
            child: TileItem()),
      ),
      itemCount: productData.length,
    );
  }
}
