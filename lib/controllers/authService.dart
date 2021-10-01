import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthController {
  final isLogged = false.obs;

  final FirebaseAuth _firebaseAuth;
  String? name;

  AuthController(this._firebaseAuth);

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();
}
