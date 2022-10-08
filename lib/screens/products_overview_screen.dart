import 'package:ajker_dordam/screens/bazar_list_screen.dart';
import 'package:flutter/material.dart';

import '../widgets/app_drawer.dart';
import '../widgets/list_tiles.dart';

class ProductsOverviewScreen extends StatelessWidget {
  const ProductsOverviewScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text(
            "আজকের দরদাম",
            style: TextStyle(
                fontFamily: 'Mina Regular', color: Colors.black, fontSize: 24),
          ),
          iconTheme: IconThemeData(color: Colors.black),
          actions: [
            IconButton(onPressed: () {}, icon: Icon(Icons.search_sharp)),
            IconButton(onPressed: () {
              Navigator.of(context).pushNamed(BazarListScreen.routeName);
            }, icon: Icon(Icons.shopping_basket))
          ],
        ),
        drawer: AppDrawer(),
        body: Column(children: [
          Container(
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.height * 0.15,
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(90),
                    topRight: Radius.circular(70)),
            ),
            padding: EdgeInsets.all(3),
            child: Text("আর নয় অতিরিক্ত মূল্যে ক্রয় বাজার হোক শান্তিময়",textAlign: TextAlign.center,style: TextStyle(fontSize: 30,fontFamily: 'Mina Bold',fontStyle: FontStyle.italic,color: Colors.white),),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.72,
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: ListTiles(),
          ),
        ]));
  }
}
