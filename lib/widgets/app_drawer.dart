import 'package:flutter/material.dart';

import '../main.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            color: Theme.of(context).primaryColor,
            width: double.infinity,
            height: 200,
            padding: EdgeInsets.only(top: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  height: 100,
                  child: CircleAvatar(
                      radius: 80,
                      backgroundImage: Image.network(
                              "https://drive.google.com/uc?export=view&id=1hXGeOX_bocFOk8GQQ4HPELelMD92ET0Y")
                          .image),
                ),
                Text(
                  "Nokibul",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          ListTile(
            title: Text("আজকের দরদাম"),
          ),
          Divider( height: 5),
          ListTile(
            title: Text("অভিযোগ করুন"),
          ),
          Divider( height: 5),
          ListTile(
            title: Text("মূল্যের লেখচিত্র"),
          ),
          Divider( height: 5),
          ListTile(
            title: Text("মূল্যছাড়"),
          ),
          Divider(
            height: 5,
          ),
          ListTile(
            title: Text("সাহায্য"),
          ),
          Divider(
            height: 20,
          ),
          ListTile(
            title: Text("লগ আউট"),
          )
        ],
      ),
    );
  }
}
