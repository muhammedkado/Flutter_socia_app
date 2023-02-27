import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socia_app/layout/cubit/state.dart';
import 'package:socia_app/model/post_model.dart';
import 'package:socia_app/model/user_model.dart';
import 'package:socia_app/modules/settings/setting_screeen.dart';
import 'package:socia_app/modules/users/users_screeen.dart';

import '../../modules/feeds/feeds_screen.dart';
import '../../modules/chats/chat_screen.dart';
import '../../sherd/components/constants.dart';

class SocialCubit extends Cubit<SocialStates> {
  SocialCubit() : super(SocialInitialState());

  static SocialCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  List<Widget> screen = [
    FeedScreen(),
    ChatScreen(),
    UsersScreen(),
    SettingScreen(),
  ];

  List<String> title = [
    'Home ',
    'Chat',
    'Users',
    'Setting',
  ];

  void changeNavBar(int index) {
    currentIndex = index;
    emit(ChangeNavBarSuccessState());
  }

  UserModel? userModel;

  void getUserData() {
    emit(GetUserLoadingState());
    FirebaseFirestore.instance.collection('user').doc(uId).get().then((value) {
      userModel = UserModel.fromJson(value.data()!);
      print(value.data());
      emit(GetUserSuccessState());
    }).catchError((onError) {
      emit(GetUserErrorState());
    });
  }

  File? profileImage;
  var picker = ImagePicker();

  Future<void> getProfileImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      emit(GetUserImagePickedSuccessState());
    } else {
      print('Not image selected ');
      emit(GetUserImagePickedErrorState());
    }
  }

  File? coverImage;

  Future<void> getCoverImage() async {
    final CoverpickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (CoverpickedFile != null) {
      coverImage = File(CoverpickedFile.path);
      emit(GetUserCoverImagePickedSuccessState());
    } else {
      print('Not image selected ');
      emit(GetUserCoverImagePickedErrorState());
    }
  }

  String profileImageUrl = '';

  void uploadProfileImage({
    required String name,
    required String phone,
    required String bio,
  }) async {
    emit(UpdateUserprofileImageLoadingState());
    await FirebaseStorage.instance
        .ref()
        .child('user/${Uri.file(profileImage!.path).pathSegments.last}')
        .putFile(profileImage!)
        .then((vlaue) async {
      //print(vlaue.ref.getDownloadURL());
      profileImageUrl = await vlaue.ref.getDownloadURL();
      emit(UploadProfileImagePickedSuccessState());
      updateUserData(
        phone: phone,
        bio: bio,
        name: name,
        image: profileImageUrl,
      );
    }).catchError((onError) {
      emit(UploadProfileImagePickedErrorState());
    });
  }

  String coverImageUrl = '';

  void uploadCoverImage({
    required String name,
    required String phone,
    required String bio,
  }) async {
    emit(UpdateUserCoverImageLoadingState());
    await FirebaseStorage.instance
        .ref()
        .child('user/${Uri.file(coverImage!.path).pathSegments.last}')
        .putFile(coverImage!)
        .then((vlaue) async {
      emit(UploadCoverImagePickedSuccessState());
      coverImageUrl = await vlaue.ref.getDownloadURL();
      updateUserData(
        phone: phone,
        bio: bio,
        name: name,
        cover: coverImageUrl,
      );
    }).catchError((onError) {
      emit(UploadCoverImagePickedErrorState());
    });
  }

  void updateUserData({
    required String name,
    required String phone,
    required String bio,
    String? image,
    String? cover,
  }) {
    UserModel model = UserModel(
      name: name,
      bio: bio,
      isEmailVerified: false,
      phone: phone,
      email: userModel!.email,
      image: image ?? userModel!.image,
      cover: cover ?? userModel!.cover,
      brithDay: userModel!.brithDay,
      country: userModel!.country,
      gender: userModel!.gender,
      uId: userModel!.uId,
    );
    emit(UpdateUserDataLoadingState());
    FirebaseFirestore.instance
        .collection('user')
        .doc(userModel!.uId)
        .update(model.toMap())
        .then((value) {
      getUserData();
    }).catchError((onError) {
      emit(UpdateUserDataErrorState());
    });
  }

  File? postImage;

  Future<void> getPostImage() async {
    final postPickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (postPickedFile != null) {
      postImage = File(postPickedFile.path);
      emit(GetPostImagePickedSuccessState());
    } else {
      print('Not image selected ');
      emit(GetUPostImagePickedErrorState());
    }
  }

  String postImageUrl = '';

  void uploadPostImage({
    required String time,
    required String text,
  }) async {
    emit(UploadPostImageLoadingState());
    await FirebaseStorage.instance
        .ref()
        .child('posts/${Uri.file(postImage!.path).pathSegments.last}')
        .putFile(postImage!)
        .then((vlaue) async {
      //print(vlaue.ref.getDownloadURL());
      postImageUrl = await vlaue.ref.getDownloadURL();
      createPost(time: time, text: text, postImage: postImageUrl);
      emit(UploadPostImageSuccessState());
    }).catchError((onError) {
      emit(UploadPostImageErrorState());
    });
  }

  void createPost({
    required String time,
    required String text,
    String? postImage,
  }) {
    PostModel model = PostModel(
      time:time,
      name: userModel!.name,uId: userModel!.uId,
      image: userModel!.image,
      text: text,

      postImage: postImage ?? '',
    );
    emit(CreatePostLoadingState());
    FirebaseFirestore.instance
        .collection('posts')
        .add(model.toMap())
        .then((value) {
      emit(CreatePostSuccessState());
    }).catchError((onError) {
      emit(CreatePostErrorState());
    });
  }
}
