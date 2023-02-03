import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  final User? user;

  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final User? user;

  @override
  void initState() {
    super.initState();
    user = widget.user;
    print(user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile Screen")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Signed in by user: ", style: TextStyle(fontSize: 20)),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: user?.photoURL != null
                    ? SizedBox(
                        height: 150,
                        width: 150,
                        child: Image.network(user!.photoURL!, fit: BoxFit.cover,))
                    : const SizedBox(),
              ),
            ),
            Text(
              "Name: ${user?.displayName}",
              style: const TextStyle(fontSize: 20),
            ),
            Text(
              "Email: ${user?.email}",
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
