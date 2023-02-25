// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socia_app/model/user_model.dart';
import 'package:socia_app/modules/register/cubit/states.dart';
import 'package:socia_app/sherd/components/components.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitialState());

  static RegisterCubit get(context) => BlocProvider.of(context);

  IconData suffix = Icons.visibility_outlined;
  bool isPassword = false;

  void changePasswordVisibility() {
    isPassword = !isPassword;
    suffix =
        isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(RegisterChangePasswordVisibilityState());
  }

  var gender;

  genderDropdown(value) {
    gender = value.toString();
    emit(RegisterGenderSuccessState());
  }

  String chooseCountry = 'Choose your country';

  countryChoose(value) {
    chooseCountry = value;
    emit(RegisterCountrySuccessState());
  }

  bool? isAgreeTerms = false;

  void checkBox(value) {
    isAgreeTerms = value;
    emit(RegisterCheckBoxState());
  }

  void createUser({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String brithDay,
    required String country,
    required String gender,
    String? uId,
  }) {
    emit(CreateLoadingState());
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: email,
      password: password,
    ).then((value) {
      saveUserInfo(
          isEmailVerified: false,
          name: name,
          email: email,
          phone: phone,
          brithDay: brithDay,
          country: country,
          gender: gender,
          uId: value.user!.uid);
      ShowTost(msg: 'User Register Success', state: TostState.SUCCESS);
      emit(CreateSuccessState());
    }).catchError((Error) {
      ShowTost(msg: '${Error.toString()}', state: TostState.ERROR);
      emit(CreateErrorState());
    });
  }

  void saveUserInfo({
    required isEmailVerified,
    required name,
    required email,
    required phone,
    required brithDay,
    required country,
    required gender,
    required uId,
  }) {
    UserModel user = UserModel(
      isEmailVerified: isEmailVerified,
      name: name,
      email: email,
      phone: phone,
      brithDay: brithDay,
      country: country,
      gender: gender,
      uId: uId,
    );

    FirebaseFirestore.instance
        .collection('user')
        .doc(uId)
        .set(user.toMap())
        .then((value) {
      emit(SaveInfoSuccessState());
    })
        .catchError((onError) {
      emit(SaveInfoErrorState());
      print('=============>${onError.toString()}');
    });
  }
}
