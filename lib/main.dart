import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import './providers/products.dart';
import './providers/bazar_list.dart';
import './providers/shops.dart';
import './providers/complains.dart';
import './screens/complain_confirm_screen.dart';
import './screens/image_picker_screen.dart';

import './screens/complain_screen.dart';
import './screens/products_overview_screen.dart';
import './screens/bazar_list_screen.dart';
import './screens/scanner_screen.dart';


Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static Color backColor = Color(0xff57DDDD);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Products()),
        ChangeNotifierProvider.value(value: BazarList()),
        ChangeNotifierProvider.value(value: Shops()),
        ChangeNotifierProvider.value(value: Complains())
      ],
      child: MaterialApp(
        title: 'Ajker Dordam',
        theme: ThemeData(
          primaryColor: backColor,
        ),
        home: ProductsOverviewScreen(),
        routes: {
          ProductsOverviewScreen.routeName: (context) => ProductsOverviewScreen(),
          BazarListScreen.routeName: (context) => BazarListScreen(),
          ComplainScreen.routeName: (context) => ComplainScreen(),
          ScannerScreen.routeName: (context) => ScannerScreen(),
          ImagePickerScreen.routeName: (context) => ImagePickerScreen(),
          ComplainConfirmScreen.routeName: (context) => ComplainConfirmScreen()
        },
        debugShowCheckedModeBanner: false,
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
