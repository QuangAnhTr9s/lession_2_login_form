import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lession_2_login_form/custom_widget/custom_textfield.dart';
import 'package:lession_2_login_form/login/login_screen.dart';
import 'package:lession_2_login_form/sign_up/sign_up_screen_bloc.dart';

class SignUpScreen extends StatefulWidget {

  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  //TextEditingController
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _secondPasswordController = TextEditingController();

  // TextEditingController _emailController = TextEditingController();
  SignUpScreenBloc _signUpScreenBloc = SignUpScreenBloc();
  @override
  void dispose() {
    _signUpScreenBloc.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sign Up"), centerTitle: true,),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //input email
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: StreamBuilder<String>(
                stream: _signUpScreenBloc.userNameStream,
                builder: (context, snapshotTextField) {
                  final errorTextEmail = snapshotTextField.hasError
                      ? snapshotTextField.error.toString()
                      : null;
                  return MyTextField(placeHolder: 'Enter your email', textEditingController: _emailController, obscureText: false,errorText: errorTextEmail,);
                }
              ),
            ),

            //input password
            buildInputPassword(_signUpScreenBloc.isShowPasswordStream,
                _signUpScreenBloc.changeShowPassword,_signUpScreenBloc.passwordStream, 'Enter your password', _passwordController,),

            //input second password
            buildInputPassword(_signUpScreenBloc.isShowSecondPasswordStream,
                _signUpScreenBloc.changeShowSecondPassword,_signUpScreenBloc.isCorrectPasswordStream, 'Re-enter the password again', _secondPasswordController ),

            //button Sign up
            InkWell(
              onTap: () {
                checkValidUser();
              },
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                height: 48,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.blue),
               child: Center(child: Text("SIGN UP", style: TextStyle(fontSize: 18, color: Colors.white),)),
              ),
            )
          ],

        ),
      ),
    );
  }

  Widget buildInputPassword(
      Stream<bool> isShowPasswordStream, Function() changeShowPassword,
      Stream<String> passwordStream, String placeHolder,
      TextEditingController textEditingController) {
    return Padding(
            padding: const EdgeInsets.all(8.0),
            child: StreamBuilder<bool>(
                // stream: _signUpScreenBloc.isShowPasswordStream,
                stream: isShowPasswordStream,
                builder: (context, snapshotIsShowPassword) {
                  final isShowPassword =
                      snapshotIsShowPassword.data ?? false;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.end,
                        children: [
                          //build Show/Hide Password
                          InkWell(
                            onTap: () {
                              // _signUpScreenBloc.changeShowPassword();
                              changeShowPassword();
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
                          stream: passwordStream,
                          builder: (context, snapshotTextField) {
                            final errorTextPassword = snapshotTextField.hasError
                                ? snapshotTextField.error.toString()
                                : null;
                            return MyTextField(placeHolder: placeHolder, textEditingController: textEditingController, obscureText: !isShowPassword,errorText: errorTextPassword,);
                          }
                      ),
                    ],
                  );
                }),
          );
  }
  Future checkValidUser() async{
    if (_signUpScreenBloc.isValidInfo(
        _emailController.text, _passwordController.text, _secondPasswordController.text)) {
      showDialog(context: context, builder: (context) => const Center(child: CircularProgressIndicator(),),);
      try{
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: _emailController.text, password: _passwordController.text);
      } on FirebaseAuthException catch (e){
        print(e);
      }
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen(),));
    }
  }
}
