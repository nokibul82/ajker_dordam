import 'package:ajker_dordam/screens/products_overview_screen.dart';
import 'package:flutter/material.dart';

import 'package:ajker_dordam/main.dart';

class ComplainSuccessScreen extends StatelessWidget {
  static const routeName = "/complainSuccessScreen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          alignment: Alignment.topCenter,
          clipBehavior: Clip.none,
          children: [
            Positioned(
              child: Image.asset(
                "assets/images/success.gif",
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              bottom: 0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                          context, ProductsOverviewScreen.routeName);
                    },
                    child: Text("Back to Home", style: TextStyle(fontSize: 24)),
                    style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).primaryColor,
                        fixedSize: Size(300, 50)),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
