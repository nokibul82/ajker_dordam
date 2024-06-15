import 'package:ajker_dordam/main.dart';
import 'package:ajker_dordam/screens/upload_image_get_url.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../screens/products_overview_screen.dart';
import '../screens/complain_screen.dart';
import '../screens/user_shops_screen.dart';
import '../screens/users_products_screen.dart';
import '../models/auth.dart';
import '../screens/help_screen.dart';

class AppDrawer extends StatefulWidget {
  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  bool _isConsumer = true;
  bool _isLoading = true;
  var _user = FirebaseAuth.instance.currentUser;
  var userName = "";
  var userPhone = "";
  var userEmail = "";

  final textStyle =
      new TextStyle(fontFamily: 'Mina Regular', color: Colors.black);

  @override
  void initState() {
    applyRole();
    super.initState();
  }

  void applyRole() async {
    var document = await FirebaseFirestore.instance
        .collection("users")
        .doc(_user?.uid)
        .get()
        .then((DocumentSnapshot snapshot) {
      if (snapshot.exists) {
        if (snapshot.get('user') == 'customer') {
          _isConsumer = true;
        } else {
          _isConsumer = false;
        }
        userName = snapshot.get('name');
        userPhone = snapshot.get('phone');
        userEmail = snapshot.get("email");
      }
      _isLoading = false;
      setState(() {});
    }).onError((error, stackTrace) {
      print(
          "===============Error from app drawer init ===============\n=============== {$error} ==============");
    });
  }

  Future<void> signOut() async {
    await Auth().signOut();
  }

  Widget _adminOptions() {
    return Column(
      children: [
        ListTile(
          onTap: () {
            Navigator.of(context)
                .pushReplacementNamed(ProductsOverviewScreen.routeName);
          },
          leading: Icon(Icons.price_check),
          title: Text("আজকের দরদাম", style: textStyle),
        ),
        Divider(thickness: 2, height: 5),
        ListTile(
          onTap: () {
            Navigator.of(context)
                .pushReplacementNamed(ComplainScreen.routeName);
          },
          leading: Icon(Icons.warning_amber),
          title: Text("অভিযোগ করুন", style: textStyle),
        ),
        Divider(thickness: 2, height: 5),
        ListTile(
          onTap: () {
            Navigator.of(context)
                .pushReplacementNamed(UserProductsScreen.routeName);
          },
          leading: Icon(Icons.add_task),
          title: Text("পণ্য যোগ / হালনাগাদ", style: textStyle),
        ),
        Divider(thickness: 2, height: 5),
        ListTile(
          onTap: () {
            Navigator.of(context)
                .pushReplacementNamed(UserShopsScreen.routeName);
          },
          leading: Icon(Icons.add_business),
          title: Text("দোকান যোগ / হালনাগাদ", style: textStyle),
        ),
      ],
    );
  }

  Widget _consumerOptions() {
    return Column(
      children: [
        ListTile(
          onTap: () {
            Navigator.of(context)
                .pushReplacementNamed(ProductsOverviewScreen.routeName);
          },
          leading: Icon(Icons.price_check),
          title: Text("আজকের দরদাম", style: textStyle),
        ),
        Divider(thickness: 2, height: 5),
        ListTile(
          onTap: () {
            Navigator.of(context)
                .pushReplacementNamed(ComplainScreen.routeName);
          },
          leading: Icon(Icons.warning_amber),
          title: Text("অভিযোগ করুন", style: textStyle),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: _isLoading ? Center(child: CircularProgressIndicator(color: Theme.of(context).primaryColor,)): Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          color: Theme.of(context).primaryColor,
          width: double.infinity,
          height: 200,
          padding: EdgeInsets.only(top: 50.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 10),
                height: 100,
                child: CircleAvatar(
                  radius: 90,
                  child: Text(
                    "Hi,\n${userName}",
                    style: TextStyle(
                        fontFamily: 'Mina Regular',
                        color: Colors.black,
                        fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  backgroundColor: Colors.white,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.email, size: 12),
                  Text(
                    userEmail,
                    style: TextStyle(
                        fontFamily: 'Mina Regular',
                        color: Colors.black87,
                        fontSize: 10),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.phone, size: 12),
                  Text(
                    userPhone,
                    style: TextStyle(
                        fontFamily: 'Mina Regular',
                        color: Colors.black87,
                        fontSize: 10),
                  ),
                ],
              )
            ],
          ),
        ),
        _isConsumer ? _consumerOptions() : _adminOptions(),
        Divider(thickness: 2, height: 5),
        ListTile(
          onTap: ()  {
            Navigator.of(context).pushReplacementNamed(HelpScreem.routeName) ;
          },
          leading: Icon(Icons.help_center_outlined),
          title: Text("সাহায্য", style: textStyle),
        ),
        Divider(thickness: 2, height: 5),
        ListTile(
          onTap: () async {
           await signOut();
          },
          leading: Icon(Icons.logout),
          title: Text("লগ আউট", style: textStyle),
        )
      ],
    ));
  }
}
