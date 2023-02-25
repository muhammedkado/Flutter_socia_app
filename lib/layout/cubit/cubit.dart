import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socia_app/layout/cubit/state.dart';
import 'package:socia_app/model/user_model.dart';

import '../../modules/test.dart';
import '../../modules/test2.dart';
import '../../sherd/components/constants.dart';

class SocialCubit extends Cubit<SocialStates> {
  SocialCubit() : super(SocialInitialState());

  static SocialCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  List<Widget> screen = [
    Test1(),
    Test2(),
  ];
  List<String> title = [
    'Home',
    'My Project',
    // 'F.A.Q',

  ];

  void changeNavBar(int index) {
    currentIndex = index;
    emit(ChangeNavBarSuccessState());
  }
UserModel? userModel;
  void getUserData() {
    emit(GetUserLoadingState());
    FirebaseFirestore.instance
        .collection('user')
        .doc(uId)
        .get()
        .then((value) {
      userModel=UserModel.fromJson(value.data()!);
          print(value.data());
      emit(GetUserSuccessState());
    }).catchError((onError) {
      emit(GetUserErrorState());
    });
  }
}
