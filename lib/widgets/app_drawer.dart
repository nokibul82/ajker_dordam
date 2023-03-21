import 'package:ajker_dordam/screens/upload_image_get_url.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../screens/products_overview_screen.dart';
import '../screens/complain_screen.dart';
import '../screens/user_shops_screen.dart';
import '../screens/users_products_screen.dart';
import '../models/auth.dart';

class AppDrawer extends StatefulWidget {
  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  bool _isConsumer = true;
  var _user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    applyRole();
    super.initState();
  }

  void applyRole(){
    var document = FirebaseFirestore.instance
        .collection("users")
        .doc(_user.uid)
        .get()
        .then((DocumentSnapshot snapshot) {
      snapshot.exists ? _isConsumer = true : _isConsumer = false;
      setState(() {

      });
    }).onError((error, stackTrace){print("===============Error from app drawer init ===============\n=============== {$error} ==============");});
  }

  Future<void> signOut() async {
    await Auth().signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: _isConsumer
            ? Column(
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
                                      "https://thumbs.dreamstime.com/b/user-icon-person-black-symbol-human-avatar-silhouette-admin-profile-picture-illustration-vector-isolated-white-203619043.jpg")
                                  .image),
                        ),
                        Text(
                          _user.email,
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
                      Navigator.of(context).pushReplacementNamed(
                          ProductsOverviewScreen.routeName);
                    },
                    leading: Icon(Icons.price_check),
                    title: Text("আজকের দরদাম"),
                  ),
                  Divider(thickness: 2, height: 5),
                  ListTile(
                    onTap: () {
                      Navigator.of(context)
                          .pushReplacementNamed(ComplainScreen.routeName);
                    },
                    leading: Icon(Icons.warning_amber),
                    title: Text("অভিযোগ করুন"),
                  ),
                  Divider(thickness: 2, height: 5),
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
                    onTap: () {
                      signOut();
                    },
                    leading: Icon(Icons.logout),
                    title: Text("লগ আউট"),
                  )
                ],
              )
            : Column(
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
                                      "https://thumbs.dreamstime.com/b/user-icon-person-black-symbol-human-avatar-silhouette-admin-profile-picture-illustration-vector-isolated-white-203619043.jpg")
                                  .image),
                        ),
                        Text(
                          _user.email,
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
                      Navigator.of(context).pushReplacementNamed(
                          ProductsOverviewScreen.routeName);
                    },
                    leading: Icon(Icons.price_check),
                    title: Text("আজকের দরদাম"),
                  ),
                  Divider(thickness: 2, height: 5),
                  ListTile(
                    onTap: () {
                      Navigator.of(context)
                          .pushReplacementNamed(ComplainScreen.routeName);
                    },
                    leading: Icon(Icons.warning_amber),
                    title: Text("অভিযোগ করুন"),
                  ),
                  Divider(thickness: 2, height: 5),
                  ListTile(
                    onTap: () {
                      Navigator.of(context)
                          .pushReplacementNamed(UserProductsScreen.routeName);
                    },
                    leading: Icon(Icons.add_task),
                    title: Text("পণ্য যোগ / হালনাগাদ"),
                  ),
                  Divider(thickness: 2, height: 5),
                  ListTile(
                    onTap: () {
                      Navigator.of(context)
                          .pushReplacementNamed(UserShopsScreen.routeName);
                    },
                    leading: Icon(Icons.add_business),
                    title: Text("দোকান যোগ / হালনাগাদ"),
                  ),
                  Divider(thickness: 2, height: 5),
                  ListTile(
                    onTap: () {
                      Navigator.of(context)
                          .pushReplacementNamed(UploadImageGetUrl.routeName);
                    },
                    leading: Icon(Icons.file_upload_outlined),
                    title: Text("ছবি আপলোড"),
                  ),
                  Divider(thickness: 2, height: 5),
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
                    onTap: () {
                      signOut();
                    },
                    leading: Icon(Icons.logout),
                    title: Text("লগ আউট"),
                  )
                ],
              ));
  }
}
