import 'package:flutter/material.dart';

class ComplainConfirmScreen extends StatelessWidget {
  const ComplainConfirmScreen({Key key}) : super(key: key);

  static const routeName = "/complainConfirmScreen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Confirm Complain"),
      )
    );
  }
}
