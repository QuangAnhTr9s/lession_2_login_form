import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lession_2_login_form/base/fire_base/fire_auth.dart';

import '../auth/login/login_screen.dart';
import '../profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  final User? user;
  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Auth _auth = Auth();
  late User? user;
  @override
  void initState() {
    user = widget.user;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Screen"),
        centerTitle: true,
      ),
      body: Center(
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
                await _auth.signOut();
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),(route) => false,);
              },
              child: const Text(
                'Sign out',
                style: TextStyle(fontSize: 20),
              )),


        ]),
      ),
    );
  }
}
