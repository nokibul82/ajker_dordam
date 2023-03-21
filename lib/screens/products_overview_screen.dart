import 'package:ajker_dordam/main.dart';
import 'package:ajker_dordam/screens/bazar_list_screen.dart';
import 'package:flutter/material.dart';

import '../widgets/app_drawer.dart';
import '../widgets/list_tiles.dart';

class ProductsOverviewScreen extends StatelessWidget {
  const ProductsOverviewScreen({Key key}) : super(key: key);
  static const routeName = "/productsOverviewScreen";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyApp.backColor,
        title: Text(
          "আজকের দরদাম",
          style: TextStyle(
              fontFamily: 'Mina Regular', color: Colors.black, fontSize: 22),
        ),
        iconTheme: IconThemeData(color: Colors.black),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        actions: [
          //IconButton(onPressed: () {}, icon: Icon(Icons.search_sharp)),
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(BazarListScreen.routeName);
              },
              icon: Icon(Icons.shopping_basket))
        ],
      ),
      drawer: AppDrawer(),
      body: Column(
          children: [
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40), topRight: Radius.circular(40))),
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          color: MyApp.backColor,
          child: Container(
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.height * 0.125,
            width: double.infinity,
            child: Text(
              "আর নয় অতিরিক্ত মূল্যে ক্রয়\nবাজার হোক শান্তিময়",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 28,
                  fontFamily: 'Mina Bold',
                  fontStyle: FontStyle.italic,
                  color: Colors.white),
            ),
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.73,
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: ListTiles(),
        ),
      ]),
    );
  }
}
