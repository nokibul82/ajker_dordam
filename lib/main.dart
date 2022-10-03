import 'package:ajker_dordam/screens/ProductsOverviewScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/Products.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static Color color = Color(0xff57DDDD);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Products())
      ],
      child: MaterialApp(
        title: 'Ajker Dordam',
        theme: ThemeData(
          primaryColor: color,
        ),
        home: ProductsOverviewScreen(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ajker Dordam"),
      ),
      body: Center(child: Text("Lets\'s build an app")),
    );
  }
}
