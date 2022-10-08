import 'package:ajker_dordam/providers/bazar_list.dart';
import 'package:ajker_dordam/screens/products_overview_screen.dart';
import './screens/bazar_list_screen.dart';
import 'package:ajker_dordam/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/products.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static Color color = Color(0xff57DDDD);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Products()),
        ChangeNotifierProvider.value(value: BazarList())
      ],
      child: MaterialApp(
        title: 'Ajker Dordam',
        theme: ThemeData(
          primaryColor: color,
        ),
        home: ProductsOverviewScreen(),
        routes: {
          BazarListScreen.routeName: (context) => BazarListScreen()
        },
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
