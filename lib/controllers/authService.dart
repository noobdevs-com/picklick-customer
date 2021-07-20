import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:picklick_customer/models/accountUser.dart';

class AuthController {
  final isLogged = false.obs;

  final FirebaseAuth _firebaseAuth;
  String? name;

  AuthController(this._firebaseAuth);

  AccountUser? _accountUserFireBase(User? user) {
    return user != null ? AccountUser(uid: user.uid) : null;
  }

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();
}
