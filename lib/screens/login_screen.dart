import '../main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/auth.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String errorMessage = '';
  bool isLogin = true;
  bool _isObscure = true;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  Future<void> signInWithEmailAndPassword() async {
    try {
      await Auth().sighWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text);
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Future<void> createUserWithEmailAndPassword() async {
    try {
      var email = _emailController.text;
      var password = _passwordController.text;
      await Auth()
          .createUserWithEmailAndPassword(email: email, password: password);
      await postDetailsToFirestore(email);
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Future<void> postDetailsToFirestore(String email) async {
    var user = Auth().currentUser;
    CollectionReference ref = FirebaseFirestore.instance.collection("users");
    await ref.doc(user.uid).set({'email': email});
  }

  Widget _tittle() {
    return const Text("Firebase Auth");
  }

  Widget _errorMessage() {
    return Text(
      errorMessage.isEmpty ? "" : "$errorMessage",
      style: TextStyle(color: Colors.red),
    );
  }

  Widget _submitButton() {
    return SizedBox(
      height: 40,
      width: MediaQuery.of(context).size.width * 0.8,
      child: ElevatedButton(
        onPressed:
            isLogin ? signInWithEmailAndPassword : createUserWithEmailAndPassword,
        child: Text(isLogin ? "Login" : "Register",style: TextStyle(fontSize: 18,color: Colors.black,fontFamily: 'Mina Regular'),),

        style: ElevatedButton.styleFrom(primary: Theme.of(context).primaryColor,shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10)))),
      ),
    );
  }

  Widget _loginOrRegisterButton() {
    return TextButton(
      onPressed: () {
        setState(() {
          isLogin = !isLogin;
        });
      },
      child: Text(isLogin ? "Register Instead" : "Login Instead",style: TextStyle(fontFamily: 'Mina Regular'),),
      style: TextButton.styleFrom(primary: Theme.of(context).primaryColor,),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/logo.png"),
            SizedBox(height: 10),
            Text("Login / Register",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,fontFamily: 'Mina Regular')),
            SizedBox(height: 15),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Email',
                  enabled: true,
                  contentPadding:
                      const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        new BorderSide(color: Theme.of(context).primaryColor),
                    borderRadius: new BorderRadius.circular(10),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide:
                        new BorderSide(color: Theme.of(context).primaryColor),
                    borderRadius: new BorderRadius.circular(11),
                  )),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _passwordController,
              obscureText: _isObscure,
              decoration: InputDecoration(
                  suffixIconColor: Theme.of(context).primaryColor,
                  suffixIcon: IconButton(
                      onPressed: () => setState(() {
                            _isObscure = !_isObscure;
                          }),
                      icon: Icon(_isObscure
                          ? Icons.visibility
                          : Icons.visibility_off)),
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Password',
                  enabled: true,
                  contentPadding:
                      const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        new BorderSide(color: Theme.of(context).primaryColor),
                    borderRadius: new BorderRadius.circular(10),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide:
                        new BorderSide(color: Theme.of(context).primaryColor),
                    borderRadius: new BorderRadius.circular(11),
                  )),
              keyboardType: TextInputType.text,
            ),
            _errorMessage(),
            SizedBox(height: 10),
            _submitButton(),
            SizedBox(height: 5),
            _loginOrRegisterButton(),
          ],
        ),
      ),
    );
  }
}
