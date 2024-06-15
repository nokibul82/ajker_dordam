import 'package:flutter/material.dart';
import 'package:ajker_dordam/main.dart';

class MyAppBar extends StatelessWidget{

  final String title;

  const MyAppBar({required this.title});
  @override
  Widget build(BuildContext context) {
    return AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          title,
          style: TextStyle(
              fontFamily: 'Mina Regular',
              color: Colors.black,
              fontSize: 24),
        ),
        iconTheme: IconThemeData(color: Colors.black),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ));
    throw UnimplementedError();
  }

}
