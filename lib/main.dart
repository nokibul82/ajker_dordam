import 'package:ajker_dordam/screens/help_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:ajker_dordam/screens/edit_product_screen.dart';
import 'package:ajker_dordam/screens/complain_history_screen.dart';
import 'package:ajker_dordam/screens/complain_success_screen.dart';
import 'package:ajker_dordam/screens/edit_shop_screen.dart';
import 'package:ajker_dordam/screens/login_screen.dart';

import './screens/qr_generate_screen.dart';
import 'package:ajker_dordam/screens/upload_image_get_url.dart';
import 'package:ajker_dordam/screens/user_shops_screen.dart';
import 'package:ajker_dordam/screens/users_products_screen.dart';


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

import './models/auth.dart';

enum Role {
  admin,
  customer
}

Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  final User? user = Auth().currentUser;

  static Color backColor = Color(0xff57dddd);
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
        home: MyHomePage(),
        routes: {
          ProductsOverviewScreen.routeName: (context) => ProductsOverviewScreen(Key("ProductsOverviewScreen")),
          BazarListScreen.routeName: (context) => BazarListScreen(),
          ComplainScreen.routeName: (context) => ComplainScreen(Key("ComplainScreen")),
          ScannerScreen.routeName: (context) => ScannerScreen(),
          ImagePickerScreen.routeName: (context) => ImagePickerScreen(),
          ComplainConfirmScreen.routeName: (context) => ComplainConfirmScreen(),
          ComplainSuccessScreen.routeName: (context) => ComplainSuccessScreen(),
          ComplainHistoryScreen.routeName: (context) => ComplainHistoryScreen(),
          UserProductsScreen.routeName: (context) => UserProductsScreen(),
          UserShopsScreen.routeName: (context) => UserShopsScreen(),
          EditProductScreen.routeName: (context) => EditProductScreen(),
          EditShopScreen.routeName: (context) => EditShopScreen(),
          UploadImageGetUrl.routeName: (context) => UploadImageGetUrl(),
          QrGenerateScreen.routeName: (context) => QrGenerateScreen(),
          MyHomePage.routeName: (context) => MyHomePage(),
          HelpScreem.routeName: (context) => HelpScreem()
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  static String routeName = "/myHomePage";
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(stream: Auth().authStateChanges,builder: (context, snapshot){
      return snapshot.hasData ? ProductsOverviewScreen(Key("ProductsOverviewScreen")) :LoginScreen();
    });
  }
}
