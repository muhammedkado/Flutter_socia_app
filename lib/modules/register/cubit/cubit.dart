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
    )
        .then((value) {
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
      cover: 'https://img.freepik.com/free-photo/cheerful-caucasian-girl-keeps-hands-together-near-face-looks-positively-aside-has-no-make-up-healthy-skin-wears-white-sweater-stands-purple-wall-with-blank-space-your-promotion_273609-26101.jpg?w=1060&t=st=1677340569~exp=1677341169~hmac=a70cc37ce2054d89d6da7de97de61231341faf257173dde4156244b6766286a6',
      bio: 'write you bio...',
      image:
          'https://cdn-icons-png.flaticon.com/512/983/983969.png?w=740&t=st=1677356979~exp=1677357579~hmac=98d67720a56e1823e360362ebd23fec67d4d06893b7e063c4da069af9c24d17c',
      isEmailVerified: false,
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
    }).catchError((onError) {
      emit(SaveInfoErrorState());
      print('=============>${onError.toString()}');
    });
  }
}
