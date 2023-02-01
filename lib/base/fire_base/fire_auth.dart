
import 'package:firebase_auth/firebase_auth.dart';

abstract class BaseAuth {
  Future<User?> signInWithEmailAndPassword({required String email, required String password});
  Future<void> createUserWithEmailAndPassword({required String firstName, required String lastName, required String email, required String password});
  Future<void> signOut();
  User? currentUser;
}
class Auth extends BaseAuth{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();
  @override
  User? get currentUser => _firebaseAuth.currentUser;

  @override
  Future<User?> signInWithEmailAndPassword(
      {required String email,
        required String password,}) async {
    UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    User? user = userCredential.user;
    return user;
  }

  @override
  Future<void> createUserWithEmailAndPassword(
      {required String firstName, required String lastName,
        required String email,
        required String password,}) async {
      await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}

