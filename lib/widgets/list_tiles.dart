import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import './tile_item.dart';
import '../providers/products.dart';

class ListTiles extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Provider.of<Products>(context).fetchAndSetProducts();
    final productData = Provider.of<Products>(context).items;
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

class Banner extends StatelessWidget {
  const Banner({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(70),
              topRight: Radius.circular(70))),
      margin: EdgeInsets.symmetric(horizontal: 15,vertical: 8),
      color: MyApp.backColor,
      child: Container(
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.height * 0.12,
        width: double.infinity,
        child: Text(
          "আর নয় অতিরিক্ত মূল্যে ক্রয়\nবাজার হোক শান্তিময়",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 30,
              fontFamily: 'Mina Bold',
              fontStyle: FontStyle.italic,
              color: Colors.white),
        ),
      ),
    );
  }
}

