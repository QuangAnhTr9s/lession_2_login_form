import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lession_2_login_form/network/fire_base/fire_auth.dart';
import 'package:lession_2_login_form/custom_widget/custom_circle_button.dart';
import 'package:lession_2_login_form/custom_widget/custom_divider.dart';
import 'package:lession_2_login_form/custom_widget/custom_textfield.dart';
import 'package:lession_2_login_form/network/google/google_sign_in.dart';
import 'package:lession_2_login_form/shared_preferences/shared_preferences.dart';

import '../../home/home_screen.dart';
import '../sign_up/sign_up_screen.dart';
import 'login_screen_bloc.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  // final VoidCallback showRegisterPage;
  // const LoginScreen({super.key, required this.showRegisterPage});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //init bloc
  final LoginScreenBloc _loginScreenBloc = LoginScreenBloc();

  //TextEditingController
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  //
  String _wrongLogin = '';

  //fire auth
  final Auth _auth = Auth();

  //google sign in
  /*final GoogleSignIn _googleSignIn = GoogleSignIn();*/
  final SignInWithGoogle _signInWithGoogle = SignInWithGoogle();

  //DateTime
  DateTime timeBackPressed = DateTime.now();

  @override
  void initState() {
    super.initState();
    print('Login Screen inited');
   /* //mỗi lần vào screen sign in => chưa lưu đăng nhập
    MySharedPreferences.setSaveSignIn(false);*/
  }
  @override
  void dispose() {
    _loginScreenBloc.dispose();
    print("Login screen is disposed");
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: WillPopScope(
          onWillPop: _onWillPop,
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.6),
                      blurRadius: 10,
                      spreadRadius: 5,
                    )
                  ]),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Sign in',
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    //nhập tài khoản
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Email',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          StreamBuilder<String>(
                            stream: _loginScreenBloc.userNameStream,
                            builder: (context, snapshotTextField) {
                              final errorTextUsername = snapshotTextField.hasError
                                  ? snapshotTextField.error.toString()
                                  : null;
                              return MyTextField(
                                placeHolder: 'Enter your email',
                                textEditingController: _usernameController,
                                obscureText: false,
                                errorText: errorTextUsername,
                              );
                            }
                          )
                        ],
                      ),
                    ),
                    //nhập mật khẩu
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: StreamBuilder<bool>(
                          stream: _loginScreenBloc.isShowPasswordStream,
                          builder: (context, snapshotIsShowPassword) {
                            final isShowPassword =
                                snapshotIsShowPassword.data ?? false;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Pasword',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    //build Show/Hide Password
                                    InkWell(
                                      onTap: () {
                                        _loginScreenBloc.changeShowPassword();
                                      },
                                      child: Text(
                                        isShowPassword
                                            ? 'Hide Password'
                                            : 'Show Password',
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                StreamBuilder<String>(
                                  stream: _loginScreenBloc.passwordStream,
                                  builder: (context, snapshotTextField) {
                                    final errorTextPassword = snapshotTextField.hasError
                                        ? snapshotTextField.error.toString()
                                        : null;
                                    return MyTextField(
                                      placeHolder: 'Enter your password',
                                      textEditingController: _passwordController,
                                      obscureText: !isShowPassword,
                                      errorText: errorTextPassword,
                                    );
                                  }
                                )
                              ],
                            );
                          }),
                    ),

                    //Text Wrong Login
                    _wrongLogin == '' ? const SizedBox() : Padding(padding: const EdgeInsets.only(top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(_wrongLogin, style: const TextStyle(fontSize: 16, color: Colors.red),),
                        ],
                      ),),

                    //Save login
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: StreamBuilder<bool>(
                        stream: _loginScreenBloc.isCheckedwordStream,
                        builder: (context, snapshot) {
                          bool isChecked = snapshot.data ?? false;
                          return Row(mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Checkbox(value: isChecked,
                                onChanged: (value) async {
                                _loginScreenBloc.isCheckedBox(value);
                                //lưu biến isChecked vào Shared Preferences
                                await MySharedPreferences.setSaveSignIn(value ?? false);
                              },),
                              Text(isChecked ? "Don't save sign in" : "Save sign in"),
                            ],
                          );
                        }
                      ),
                    ),

                    // nút đăng ký
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: _buildButtonSignIn('SIGN IN'),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 30),
                      child: MyDivider(text: 'OR'),
                    ),

                    // Social button
                    Padding(
                      padding: const EdgeInsets.only(top: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                           MyCircleButton(lable: 'G', color: Colors.red, onTapCircleButton: _handleGoogleSignIn),
                           MyCircleButton(lable: 'f',color: Colors.blue, onTapCircleButton: _handleFacebookSignIn),
                          MyCircleButton(lable: 'in',color: Colors.lightBlue.shade600,onTapCircleButton: _handleFacebookSignIn ),
                        ],
                      ),
                    ),

                    //Text Create new account? SIGN UP
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Create new account? ",
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ),
                          InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const SignUpScreen(),
                                    ));
                              },
                              child: const Text(
                                "SIGN UP",
                                style: TextStyle(
                                    fontSize: 18,
                                    decoration: TextDecoration.underline),
                              )),
                          /*Text.rich(TextSpan(
                              text: 'Create new account? ',
                              style: TextStyle(fontSize: 18, color: Colors.black),
                              children: [
                                TextSpan(
                                    text: 'SIGN UP',
                                    style: TextStyle(decoration: TextDecoration.underline))
                              ])),*/
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButtonSignIn(String label) {
    return Material(
      color: Colors.pink[300],
      borderRadius: BorderRadius.circular(15),
      child: InkWell(
        // splashColor: Colors.orangeAccent,
        onTap: () {
          checkValidUser();
        },
        child: SizedBox(
          height: 48,
          // decoration: BoxDecoration(color: Colors.redAccent[200], borderRadius: BorderRadius.circular(10), ),
          child: Center(
            child: Text(
              label,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> checkValidUser() async{
    if (_loginScreenBloc.isValidInfo(
        _usernameController.text, _passwordController.text)) {
      try {
        User? user = await _auth.signInWithEmailAndPassword(
          email: _usernameController.text,
          password: _passwordController.text,
        ).then((value) async{
          if (value != null) {
            showDialog(context: context, builder: (context) => const Center(child: CircularProgressIndicator(),),);
            // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen(user: value),));
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomeScreen(user: value),), (route) => false);
          }
          return null;
        },);
        print(user);

      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          setState(() {
            _wrongLogin = 'No user found for that email!';
          });
        } else if (e.code == 'wrong-password') {
          setState(() {
            _wrongLogin = 'Wrong password!';
          });
        }
      }
    }
  }
  Future<void> _handleGoogleSignIn() async {
    try {
      User? userGoogle = await _signInWithGoogle.signInWithGoogle().then((value) async {
        if (value!= null) {
          print('ok user google');
          showDialog(context: context, builder: (context) => const Center(child: CircularProgressIndicator(),),);
          // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen(user: value),));
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomeScreen(user: value),), (route) => false);
        }
        return null;
      });
    } catch (error) {
      print(error);
    }
  }

  _handleFacebookSignIn() {
  }
  //Press back 2 time to exit
  Future<bool> _onWillPop() async {
    final difference = DateTime.now().difference(timeBackPressed);
    final isExitWarning = difference >= const Duration(seconds: 2);

    timeBackPressed = DateTime.now();
    if(isExitWarning){
      const message = ' Press back again to exit ';
      await Fluttertoast.showToast(msg: message, fontSize: 16);
      return false;
    }else{
      Fluttertoast.cancel();
      return true;
    }
  }
}
