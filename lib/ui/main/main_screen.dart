import 'package:flutter/material.dart';
import 'package:lession_2_login_form/network/google/google_sign_in.dart';
import 'package:lession_2_login_form/shared_preferences/shared_preferences.dart';

import '../../network/fire_base/fire_auth.dart';
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
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>{
//dùng with WidgetsBindingObserver để check các trạng thái của app
//=> phải thêm WidgetsBinding.instance.addObserver(this) vào initState
//=> phải thêm WidgetsBinding.instance.removeObserver(this) vào dispose
//function didChangeAppLifecycleState để check các trạng thái

  //isSignIn
  bool isSignIn = false;

  //init Auth
  final Auth _auth = Auth();
  //init Google Login
  final SignInWithGoogle _signInWithGoogle = SignInWithGoogle();
  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addObserver(this);
    isSignIn = MySharedPreferences.getIsSaveSignIn();
    print("isSignIn: $isSignIn");
  }
  @override
  void dispose() {
    print("Main Screen is disposed");
    // WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
  /*@override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if(state == AppLifecycleState.detached){
      print('detached');
      //nếu ko chọn lưu đăng nhập thì sau khi tắt app => đăng xuất trên firebase luôn
      *//*if(!isSignIn) {
        await _signInWithGoogle.signOut();
        await _auth.signOut();
        print('Main Screen isSignOut');
      }*//*
    }
    if(state == AppLifecycleState.inactive){
      print("inactive");
    }if(state == AppLifecycleState.paused){
      print("paused");
    }if(state == AppLifecycleState.resumed){
      print("resumed");
    }
  }*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: Auth().authStateChanges,
        builder: (context, snapshot) {
          if(snapshot.hasData) {

            print('snapshot has data: ${snapshot.data}');
            return HomeScreen(user: snapshot.data,);
          }else if(!snapshot.hasData){
            print('snapshot has not data');
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
  /*Future<void> _signOut() async {
    await _signInWithGoogle.signOut();
    await _auth.signOut();
  }*/
}

