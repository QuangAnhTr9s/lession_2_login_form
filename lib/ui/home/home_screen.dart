import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lession_2_login_form/network/fire_base/fire_auth.dart';
import 'package:lession_2_login_form/network/google/google_sign_in.dart';
import 'package:lession_2_login_form/shared_preferences/shared_preferences.dart';

import '../auth/login/login_screen.dart';
import '../profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  final User? user;
  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  late User? user;
  final Auth _auth = Auth();
  final SignInWithGoogle _signInWithGoogle = SignInWithGoogle();
  //isSignIn
  bool isSignIn = false;
  //DateTime
  DateTime timeBackPressed = DateTime.now();
  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    /*if(state == AppLifecycleState.inactive || state == AppLifecycleState.detached) return;
    final isBackground = state == AppLifecycleState.paused;
    if(isBackground){
      print("isSignIn in background: $isSignIn");
      if(!isSignIn){
        await _signOut();
      }
      print("App is back ground");
    }*/
   /* final isDetached = state == AppLifecycleState.detached;
    if(isDetached){
      print("isSignIn - detached: $isSignIn");
      if(!isSignIn){
        await _signOut();
      }
    }*/
    if(state == AppLifecycleState.detached) {
      print('HomeScreen is detached');
      print(!isSignIn);
     /* //nếu ko chọn lưu đăng nhập thì sau khi tắt app => đăng xuất trên firebase luôn
      if(!isSignIn) {
        _signOut();
        print('Home Screen is detached and isSignIn: $isSignIn');
      }*/
    }
    /*
    if(state == AppLifecycleState.inactive){
      print("HomeScreen inactive");
    }
    if(state == AppLifecycleState.paused){
      print("HomeScreen paused");
    }
    if(state == AppLifecycleState.resumed){
      print("HomeScreenresumed");
    }*/
  }
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    user = widget.user;
    print('Home screen inited');
    print(isSignIn);
    isSignIn = MySharedPreferences.getIsSaveSignIn();
  }

  @override
  void dispose() {
     /*if(isSignIn == false) {
      _signOut();
      print('Main Screen isSignOut');
    }*/
    print("Home Screen is disposed");
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
  Future<void> _signOut() async {
    try{
       _signInWithGoogle.signOut();
       _auth.signOut();
    } catch(e){
      print('error in Home Sc: $e');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Screen"),
        centerTitle: true,
      ),
      body: WillPopScope(
        onWillPop: _onWillPop,
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Text(
              "Home Screen",
              style: TextStyle(fontSize: 18),
            ),

            //nút vào xem profile user
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ProfileScreen(user: user),
                  ));
                },
                child: const Text(
                  "Profile",
                  style: TextStyle(fontSize: 20),
                )),
            //nút đăng xuất
            ElevatedButton(
                onPressed: () async {
                  MySharedPreferences.setSaveSignIn(false);
                  await _signOut().then((value) {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const LoginScreen(),));
                    // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const LoginScreen(),),(route) => false,);
                  });
                  /*await _auth.signOut();
                  await _signInWithGoogle.signOut().then((value) {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const LoginScreen(),));
                    // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const LoginScreen(),),(route) => false,);
                  },);*/
                },
                child: const Text(
                  'Sign out',
                  style: TextStyle(fontSize: 20),
                )),
          ]),
        ),
      ),
    );
  }

  //Press back 2 time to exit
  Future<bool> _onWillPop() async {
      final difference = DateTime.now().difference(timeBackPressed);
      final isExitWarning = difference >= const Duration(seconds: 2);

      timeBackPressed = DateTime.now();
      if(isExitWarning){
        const message = ' Press back again to exit ';
        Fluttertoast.showToast(msg: message, fontSize: 16);
        return false;
      }else{
        //Press back again to cancel Toast and sign out User if isSignIn == false
         Fluttertoast.cancel();
         if(!isSignIn){
           await _signOut();
         }
        return true;
      }
  }
}
