import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lession_2_login_form/custom_widget/custom_textfield.dart';
import 'package:lession_2_login_form/home/home_screen.dart';
import 'package:lession_2_login_form/login/login_screen_bloc.dart';
import 'package:lession_2_login_form/sign_up/sign_up_screen.dart';

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

  @override
  void dispose() {
    _loginScreenBloc.dispose();
    super.dispose();
  }
  //Login function
  static Future<User?> loginUsingEmail(
      {required String email,
        required String password,
        required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided.');
      }
    }
    return user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
                    'Sign up',
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
                  // nút đăng ký
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: _buildButtonSignIn('SIGN IN'),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: _buildDivider('OR'),
                  ),

                  // Social button
                  Padding(
                    padding: const EdgeInsets.only(top: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildCircleButton('G', Colors.red),
                        _buildCircleButton('f', Colors.blue),
                        _buildCircleButton('in', Colors.lightBlue.shade600),
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
                                    builder: (context) => SignUpScreen(),
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
    );
  }

  /*Widget _buildTextField({
    required String placeHolder,
    required TextEditingController textEditingController,
    required Stream<String> stream,
    required bool obscureText,
  }) {
    return StreamBuilder<String>(
        stream: stream,
        builder: (context, snapshotTextField) {
          return TextFormField(
            obscureText: obscureText,
            cursorColor: Colors.grey,
            controller: textEditingController,
            decoration: InputDecoration(
              errorText: snapshotTextField.hasError
                  ? snapshotTextField.error.toString()
                  : null,
              //để null thì khi ko bị lỗi, textfield ko bị bôi đỏ viền
              hintText: placeHolder,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        });
  }*/

  Widget _buildButtonSignIn(String label) {
    return Material(
      color: Colors.pink[300],
      borderRadius: BorderRadius.circular(15),
      child: InkWell(
        // splashColor: Colors.orangeAccent,
        onTap: () {
          checkValidUser();
        },
        child: Container(
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

  Widget _buildCircleButton(String lable, Color color) {
    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(width: 3, color: color),
          shape: BoxShape.circle),
      child: Center(
          child: Text(
        lable,
        style:
            TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.w900),
      )),
    );
  }

  Widget _buildDivider(String label) {
    return Row(children: <Widget>[
      const Expanded(child: Divider()),
      Container(
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              border: Border.all(width: 2, color: Colors.grey),
              borderRadius: BorderRadius.circular(5)),
          child: const Padding(
            padding: EdgeInsets.all(2),
            child: Text(
              "Or",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          )),
      const Expanded(child: Divider()),
    ]);
  }

  void checkValidUser() async{
    /*// showDialog(context: context, builder: (context) => Center(child: CircularProgressIndicator(),),);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _usernameController.text, password: _passwordController.text);
    } on FirebaseAuthException catch (e){
      print(e);
    }*/
    if (_loginScreenBloc.isValidInfo(
        _usernameController.text, _passwordController.text)) {
      User? user = await loginUsingEmail(
          email: _usernameController.text,
          password: _passwordController.text,
          context: context);
      print(user);
      if (user!= null) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const HomeScreen(),));
      }
    }
  }
}
