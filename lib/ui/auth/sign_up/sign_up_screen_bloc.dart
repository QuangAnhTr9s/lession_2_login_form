import 'dart:async';

import 'package:lession_2_login_form/base/bloc/bloc.dart';
import 'package:lession_2_login_form/validations/validations.dart';

class SignUpScreenBloc extends Bloc {
  //isShowPasswod
  bool _isShowPassword = false;
  bool _isShowSecondPassword = false;

  StreamController<String> _userNameStreamController = StreamController<String>.broadcast();
  StreamController<String> _passwordStreamController = StreamController<String>.broadcast();
  StreamController<String> _secondPasswordStreamController = StreamController<String>.broadcast();
  StreamController<bool> _isShowPasswordStreamController = StreamController<bool>.broadcast();
  StreamController<bool> _isShowSecondPasswordStreamController = StreamController<bool>.broadcast();


  Stream<String> get  userNameStream => _userNameStreamController.stream;
  Stream<String> get  passwordStream => _passwordStreamController.stream;
  Stream<String> get  isCorrectPasswordStream => _secondPasswordStreamController.stream;
  Stream<bool> get  isShowPasswordStream => _isShowPasswordStreamController.stream;
  Stream<bool> get  isShowSecondPasswordStream => _isShowSecondPasswordStreamController.stream;

  void changeShowPassword(){
    _isShowPassword = !_isShowPassword;
    _isShowPasswordStreamController.sink.add(_isShowPassword);
  }
  void changeShowSecondPassword(){
    _isShowSecondPassword = !_isShowSecondPassword;
    _isShowSecondPasswordStreamController.sink.add(_isShowSecondPassword);
  }

  @override
  void dispose() {
    _userNameStreamController.close();
    _passwordStreamController.close();
    _secondPasswordStreamController.close();
    _isShowPasswordStreamController.close();
    _isShowSecondPasswordStreamController.close();
    super.dispose();
  }
  bool isValidInfo(String email, String password, String sencondPassword){
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
    if(!Validations.isValidSecondPassword(sencondPassword, password)){
      _secondPasswordStreamController.sink.addError("Password does not match!");
      return false;
    }
    _secondPasswordStreamController.sink.add('');
    return true;
  }
}
