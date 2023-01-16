import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './image_picker_screen.dart';

import '../providers/complains.dart';

class ComplainConfirmScreen extends StatelessWidget {

  static const routeName = "/complainConfirmScreen";

  @override
  Widget build(BuildContext context) {
    Complain complain = Provider.of<Complains>(context).temporaryComplain;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          "অভিযোগ যাচাই",
          style: TextStyle(
              fontFamily: 'Mina Regular', color: Colors.black, fontSize: 24),
        ),
        actions: [],
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pushReplacementNamed(ImagePickerScreen.routeName);
          },
          icon: Icon(
            Icons.arrow_back_outlined,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.black),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(complain.id),
              Text(complain.shopName),
              Text(complain.shopImageUrl),
              Text(complain.receiptImageUrl),
            ],
          ),
        ),
      ),
    );
  }
}
