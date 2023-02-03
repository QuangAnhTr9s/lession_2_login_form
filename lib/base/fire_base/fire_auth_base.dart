import 'package:firebase_auth/firebase_auth.dart';

abstract class BaseAuth {
  Future<User?> signInWithEmailAndPassword({required String email, required String password});
  Future<void> createUserWithEmailAndPassword({required String firstName, required String lastName, required String email, required String password});
  Future<void> signOut();
  User? currentUser;
}