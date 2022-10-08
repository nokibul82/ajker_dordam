import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 50,
            width: double.infinity,
            color: Theme.of(context).primaryColor,
            child: Text("Login",textAlign: TextAlign.center,style: TextStyle(fontSize: 30,fontFamily: 'Mina Bold',fontStyle: FontStyle.italic,color: Colors.white),
          )
          ),
          TextField()
        ],
      ),
    );
  }
}
