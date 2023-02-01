import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../base/fire_base/fire_auth.dart';
import '../auth/login/login_screen.dart';
import '../home/home_screen.dart';


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Login Form',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  /*//initialize Firebase
  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    //Nếu đã đăng nhập thì sẽ nhảy sang trang HomeScreen luôn
    *//*User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      showDialog(context: context, builder: (context) => const Center(child: CircularProgressIndicator(),),);
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomeScreen(user: user),), (route) => false);
    }*//*
    return firebaseApp;
  }*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: Auth().authStateChanges,
        builder: (context, snapshot) {
          User? user = FirebaseAuth.instance.currentUser;
          if(snapshot.hasData){
            return HomeScreen(user: user);
          }else if(!snapshot.hasData){
            return const LoginScreen();
          }
          /*if(snapshot.connectionState == ConnectionState.done){
            return LoginScreen();
          }*/
          return const Center(
            child: CircularProgressIndicator(),
          );
        },),
    );
  }
}