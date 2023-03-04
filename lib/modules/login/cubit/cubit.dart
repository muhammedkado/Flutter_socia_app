import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socia_app/modules/login/cubit/states.dart';
import 'package:socia_app/sherd/components/components.dart';
import 'package:socia_app/sherd/network/local/cachHelper.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitialState());

  static LoginCubit get(context) => BlocProvider.of(context);
  IconData suffix = Icons.visibility_outlined;

  bool isPassword = false;
 void ChangePasswordVisibility() {
    isPassword = !isPassword;
    suffix =
    isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(LoginChangePasswordVisibilityState());
  }
  void userLogin({required String email, required String password}) async {
    emit(LoginLoadingState());
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
          var id=value.user?.uid;
      CachHelper.saveData(key: 'uId', value: value.user!.uid).then((value) => emit(LoginSuccessState(id)));
      
    ShowTost(msg: 'Login Success', state: TostState.SUCCESS);
    }).catchError((Error){
      emit(LoginErrorState());
      ShowTost(msg: 'Login Error${Error.toString()}', state: TostState.ERROR);
    });
  }
}
