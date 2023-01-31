import 'dart:async';

import 'package:lession_2_login_form/base/bloc.dart';
import 'package:lession_2_login_form/validations/validations.dart';

class LoginScreenBloc extends Bloc {
  //isShowPasswod
  bool _isShowPassword = false;

  StreamController<String> _userNameStreamController = StreamController<String>.broadcast();
  StreamController<String> _passwordStreamController = StreamController<String>.broadcast();
  StreamController<bool> _isShowPasswordStreamController = StreamController<bool>.broadcast();

  Stream<String> get  userNameStream => _userNameStreamController.stream;
  Stream<String> get  passwordStream => _passwordStreamController.stream;
  Stream<bool> get  isShowPasswordStream => _isShowPasswordStreamController.stream;

  @override
  void dispose() {
    _userNameStreamController.close();
    _passwordStreamController.close();
    _isShowPasswordStreamController.close();
    super.dispose();
  }
  void changeShowPassword(){
    _isShowPassword = !_isShowPassword;
    _isShowPasswordStreamController.sink.add(_isShowPassword);
  }
  bool isValidInfo(String email, String password){
    if(!Validations.isValidEmail(email)){
      _userNameStreamController.sink.addError("Invalid Email!");
      return false;
    }
    _userNameStreamController.sink.add('OK');

    if(!Validations.isValidPassword(password)){
      _passwordStreamController.sink.addError("Invalid Password! must be longer than 8 characters");
      return false;
    }
    _passwordStreamController.sink.add('OK');
    return true;
  }
}
