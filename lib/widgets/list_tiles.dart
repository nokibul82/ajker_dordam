import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import './tile_item.dart';
import '../providers/products.dart';

class ListTiles extends StatefulWidget {
  @override
  State<ListTiles> createState() => _ListTilesState();
}

class _ListTilesState extends State<ListTiles> {

  late List<Product> productData;


  @override
  Widget build(BuildContext context) {
    Provider.of<Products>(context).fetchAndSetProducts();
    productData = Provider.of<Products>(context).items;
    return ListView.builder(
      itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
        value: productData[index],
        child: Card(
            elevation: 3,
            child: TileItem()),
      ),
      itemCount: productData.length,
    );
  }
}

