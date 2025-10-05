import 'package:ajker_dordam/main.dart';
import 'package:ajker_dordam/screens/bazar_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../widgets/app_drawer.dart';
import '../widgets/list_tiles.dart';
import '../widgets/tile_item.dart';

class GovtPriceListScreen extends StatelessWidget {
  const GovtPriceListScreen(Key key) : super(key: key);
  static const routeName = "/govtPriceListScreen";
  @override
  Widget build(BuildContext context) {
    Provider.of<Products>(context).fetchAndSetProducts();
    final productData = Provider.of<Products>(context).items.where((element) => element.shopId == "-OamFpGHZlCmCtBqHGFH").toList();
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: MyApp.backColor,
        title: Text(
          "সরকারি মূল্য তালিকা",
          style: TextStyle(
              fontFamily: 'Mina Regular', color: Colors.black, fontSize: 22),
        ),
        iconTheme: IconThemeData(color: Colors.black),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      drawer: AppDrawer(),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: ListView.builder(
          itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
            value: productData[index],
            child: Card(
                elevation: 3,
                child: TileItem()),
          ),
          itemCount: productData.length,
        ),
      ),
    );
  }
}
