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
  bool _isLogin = true;
  bool _isObscure = true;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
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
      final email = _emailController.text;
      final password = _passwordController.text;
      final name = _nameController.text;
      final phone = _phoneController.text;
      final user = "customer";
      await Auth()
          .createUserWithEmailAndPassword(email: email, password: password)
          .whenComplete(() => postDetailsToFirestore(name, email, phone, user,Auth().currentUser));
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
        print("${e} =========== error in create user Method ===============");
      });
    }
  }

  Future<void> postDetailsToFirestore(
      String name, String email, String phone, String user, User currentUser) async {
    try {
      CollectionReference ref = FirebaseFirestore.instance.collection("users");
      await ref
          .doc(currentUser.uid)
          .set({'email': email, 'name': name, 'phone': phone, 'user': user});
    } catch (e) {
      setState(() {
        errorMessage = e.message;
        print("${e} =========== error in post details Method ===============");
      });
    }
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
        onPressed: _isLogin
            ? signInWithEmailAndPassword
            : createUserWithEmailAndPassword,
        child: Text(
          _isLogin ? "Login" : "Register",
          style: TextStyle(
              fontSize: 18, color: Colors.black, fontFamily: 'Mina Regular'),
        ),
        style: ElevatedButton.styleFrom(
            primary: Theme.of(context).primaryColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)))),
      ),
    );
  }

  Widget _loginOrRegisterButton() {
    return TextButton(
      onPressed: () {
        setState(() {
          _isLogin = !_isLogin;
        });
      },
      child: Text(
        _isLogin
            ? "Don't have account? Register Instead"
            : "Have account? Login Instead.",
        style: TextStyle(fontFamily: 'Mina Regular'),
      ),
      style: TextButton.styleFrom(
        primary: Colors.black,
      ),
    );
  }

  Widget _nameTextField() {
    return TextField(
      controller: _nameController,
      decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: 'Name',
          enabled: true,
          contentPadding:
              const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
          focusedBorder: OutlineInputBorder(
            borderSide: new BorderSide(color: Theme.of(context).primaryColor),
            borderRadius: new BorderRadius.circular(10),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: new BorderSide(color: Theme.of(context).primaryColor),
            borderRadius: new BorderRadius.circular(11),
          )),
      keyboardType: TextInputType.name,
    );
  }

  Widget _phoneTextField() {
    return TextField(
      controller: _phoneController,
      decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: 'Phone Number',
          enabled: true,
          contentPadding:
              const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
          focusedBorder: OutlineInputBorder(
            borderSide: new BorderSide(color: Theme.of(context).primaryColor),
            borderRadius: new BorderRadius.circular(10),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: new BorderSide(color: Theme.of(context).primaryColor),
            borderRadius: new BorderRadius.circular(11),
          )),
      keyboardType: TextInputType.number,
    );
  }

  Widget _emailTextField() {
    return TextField(
      controller: _emailController,
      decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: 'Email',
          enabled: true,
          contentPadding:
              const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
          focusedBorder: OutlineInputBorder(
            borderSide: new BorderSide(color: Theme.of(context).primaryColor),
            borderRadius: new BorderRadius.circular(10),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: new BorderSide(color: Theme.of(context).primaryColor),
            borderRadius: new BorderRadius.circular(11),
          )),
      keyboardType: TextInputType.emailAddress,
    );
  }

  Widget _passwordTextField() {
    return TextField(
      controller: _passwordController,
      obscureText: _isObscure,
      decoration: InputDecoration(
          suffixIconColor: Theme.of(context).primaryColor,
          suffixIcon: IconButton(
              onPressed: () => setState(() {
                    _isObscure = !_isObscure;
                  }),
              icon: Icon(_isObscure ? Icons.visibility : Icons.visibility_off)),
          filled: true,
          fillColor: Colors.white,
          hintText: 'Password',
          enabled: true,
          contentPadding:
              const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
          focusedBorder: OutlineInputBorder(
            borderSide: new BorderSide(color: Theme.of(context).primaryColor),
            borderRadius: new BorderRadius.circular(10),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: new BorderSide(color: Theme.of(context).primaryColor),
            borderRadius: new BorderRadius.circular(11),
          )),
      keyboardType: TextInputType.text,
    );
  }

  Widget _loginTextFields() {
    return Column(
      children: [
        _emailTextField(),
        SizedBox(height: 3), //email
        _passwordTextField(), //password
      ],
    );
  }

  Widget _signupTextFields() {
    return Column(
      children: [
        _nameTextField(),
        SizedBox(height: 3),
        _phoneTextField(),
        SizedBox(height: 3),
        _emailTextField(),
        SizedBox(height: 3),
        _passwordTextField()
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/logo.png"),
            SizedBox(height: 10),
            Text("Login / Register",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Mina Regular')),
            SizedBox(height: 15),
            _isLogin ? _loginTextFields() : _signupTextFields(),
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
