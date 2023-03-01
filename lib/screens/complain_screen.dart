import 'package:flutter/material.dart';
import 'package:ajker_dordam/main.dart';
import './complain_history_screen.dart';
import './scanner_screen.dart';
import '../widgets/app_drawer.dart';

class ComplainScreen extends StatelessWidget {
  const ComplainScreen({Key key}) : super(key: key);
  static const routeName = "/complainScreen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            title: Text(
              "অভিযোগ",
              style: TextStyle(
                  fontFamily: 'Mina Regular',
                  color: Colors.black,
                  fontSize: 22),
            ),
            iconTheme: IconThemeData(color: Colors.black),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(20),
              ),
            )),
        drawer: AppDrawer(),
        body: Column(
          children: [
            Card(
              margin: EdgeInsets.all(15),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.5,
                width: double.infinity,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: MyApp.backColor.withOpacity(0.8),
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(30),
                        topLeft: Radius.circular(30))),
                child: Text(
                  "অতিরিক্ত দাম ?\nঅভিযোগ করুন",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Mina Regular',
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 44,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.94,
              height: MediaQuery.of(context).size.height * 0.1,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed(ScannerScreen.routeName);
                  },
                  style: ElevatedButton.styleFrom(
                      primary: MyApp.backColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      )),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "অভিযোগ করুন",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Mina Regular',
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 26,
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Icon(
                        Icons.warning_amber,
                        color: Colors.black,
                      )
                    ],
                  )),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.04,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.94,
              height: MediaQuery.of(context).size.height * 0.1,
              child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed(ComplainHistoryScreen.routeName);
                  },
                  style: OutlinedButton.styleFrom(
                      side: BorderSide(width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      )),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "পূর্বের অভিযোগ তালিকা",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Mina Regular',
                          color: MyApp.backColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 26,
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Icon(
                        Icons.format_list_numbered,
                        color: MyApp.backColor,
                      )
                    ],
                  )),
            )
          ],
        ));
  }
}
