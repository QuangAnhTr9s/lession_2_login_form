import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lession_2_login_form/shared_preferences/shared_preferences.dart';
import 'package:lession_2_login_form/ui/main/main_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await MySharedPreferences.initSharedPreferences();
  runApp(const MyApp());
}



