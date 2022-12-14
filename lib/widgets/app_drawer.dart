import 'package:flutter/material.dart';
import '../screens/products_overview_screen.dart';
import '../screens/complain_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            color: Theme.of(context).primaryColor,
            width: double.infinity,
            height: 200,
            padding: EdgeInsets.only(top: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
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
            onTap: () {
              Navigator.of(context).pushReplacementNamed(ProductsOverviewScreen.routeName);
            },
            leading: Icon(Icons.price_check),
            title: Text("আজকের দরদাম"),
          ),
          Divider(thickness: 2, height: 5),
          ListTile(
            onTap: () {
              Navigator.of(context).pushReplacementNamed(ComplainScreen.routeName);
            },
            leading: Icon(Icons.warning_amber),
            title: Text("অভিযোগ করুন"),
          ),
          Divider(thickness: 2, height: 5),
          ListTile(
            onTap: () {},
            leading: Icon(Icons.bar_chart),
            title: Text("মূল্যের লেখচিত্র"),
          ),
          Divider(thickness: 2, height: 5),
          ListTile(
            onTap: () {},
            leading: Icon(Icons.discount_outlined),
            title: Text("মূল্যছাড়"),
          ),
          Divider(
            thickness: 2,
            height: 5,
          ),
          ListTile(
            onTap: () {},
            leading: Icon(Icons.help_center_outlined),
            title: Text("সাহায্য"),
          ),
          Divider(
            thickness: 2,
            height: 5,
          ),
          ListTile(
            onTap: () {},
            leading: Icon(Icons.logout),
            title: Text("লগ আউট"),
          )
        ],
      ),
    );
  }
}
