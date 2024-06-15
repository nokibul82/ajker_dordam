import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> sighWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      print("Exceptiopn from sighWithEmailAndPassword ${e.toString()}");
    }
  }

  Future<void> createUserWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      print("Exceptiopn from createUserWithEmailAndPassword ${e.toString()}");
    }
  }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut().catchError((e) {
        print(e);
      });
    }catch(e){
      print("Exceptiopn from signOut ${e.toString()}");
    }
  }
}
