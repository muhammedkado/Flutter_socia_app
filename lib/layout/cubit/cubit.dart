import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socia_app/layout/cubit/state.dart';
import 'package:socia_app/model/messages_model.dart';
import 'package:socia_app/model/post_model.dart';
import 'package:socia_app/model/user_model.dart';
import 'package:socia_app/modules/settings/setting_screeen.dart';
import 'package:socia_app/modules/users/users_screeen.dart';
import 'package:socia_app/sherd/components/components.dart';
import 'package:socia_app/sherd/network/local/cachHelper.dart';
import 'package:socia_app/sherd/styles/icon_broken.dart';

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
    if (index == 1) {
      getAllUser();
    }

    currentIndex = index;
    emit(ChangeNavBarSuccessState());
  }

  UserModel? userModel;

  void getUserData() {
    emit(GetUserLoadingState());
    FirebaseFirestore.instance.collection('user').doc(uId).get().then((value) {
      userModel = UserModel.fromJson(value.data()as Map<String,dynamic>) ;
      print(value.data());
      emit(GetUserSuccessState());
    }).catchError((onError) {
      print('====>${onError.toString()}');
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
        .child('user/${Uri
        .file(profileImage!.path)
        .pathSegments
        .last}')
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
        .child('user/${Uri
        .file(coverImage!.path)
        .pathSegments
        .last}')
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
        .child('posts/${Uri
        .file(postImage!.path)
        .pathSegments
        .last}')
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
      time: time,
      name: userModel!.name,
      uId: userModel!.uId,
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

  void removePostImage() {
    postImage = null;
    emit(RemovePostImage());
  }

  List<PostModel> post = [];
  List<String> postId = [];
  List<int> likes = [];
  List<int> comments = [];

  void getPosts() {
    emit(GetPostLoadingState());
    FirebaseFirestore.instance.collection('posts').get().then((value) {
      value.docs.forEach((element) {
        element.reference.collection('likes').get().then((value) {
          likes.add(value.docs.length);
          element.reference.collection('comments').get().then((value) {
            comments.add(value.docs.length);
            postId.add(element.id);
            post.add(PostModel.fromJson(element.data()));
            emit(GetPostSuccessState());
          }).catchError((onError) {});
        }).catchError((onError) {
          emit(GetPostErrorState());
        });
      });
    }).catchError((onError) {
      print(onError.toString());
      emit(GetPostErrorState());
    });
  }

  void likePost(String postId) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(userModel!.uId)
        .set({
      'like': true,
    }).then((value) {
      emit(GetPostLikeSuccessState());
    }).catchError((Error) {
      emit(GetPostLikeErrorState());
    });
  }

  void commentPostCount(String postId) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(userModel!.uId)
        .set({
      'comments': true,
    }).then((value) {
      emit(GetPostLikeSuccessState());
    }).catchError((Error) {
      emit(GetPostLikeErrorState());
    });
  }

  List<UserModel> allUser = [];

  void getAllUser() {
    if (allUser.isEmpty) {
      emit(GetAllUserLoadingState());
      FirebaseFirestore.instance.collection('user').get().then((value) {
        value.docs.forEach((element) {
          if (element.data()['uId'] != userModel!.uId) {
            allUser.add(UserModel.fromJson(element.data()));
          }
        });
        emit(GetAllUserSuccessState());
      }).catchError((onError) {
        print(onError.toString());
        emit(GetAllUserErrorState());
      });
    }
  }

  void sendMessages({
    required String text,
     String? foto,
    required String sederId,
    required String receiverId,
    required String dateTime,
    required TextEditingController aftermessage
  }) {
    emit(UserSendMessageLoadingState());
    MessagesModel messagesModel = MessagesModel(
      text: text,
      receiverId: receiverId,
      dateTime: dateTime,
      sederId: sederId,
    );
    FirebaseFirestore.instance
        .collection('user')
        .doc(userModel!.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('message')
        .add(messagesModel.toMap())
        .then((value) {
      emit(UserSendMessageSuccessState());
      aftermessage.clear();
    }).catchError((Error) {
      emit(UserSendMessageErrorState());
    });

    FirebaseFirestore.instance
        .collection('user')
        .doc(receiverId)
        .collection('chats')
        .doc(userModel!.uId)
        .collection('message')
        .add(messagesModel.toMap())
        .then((value) {
      emit(UserSendMessageSuccessState());
    }).catchError((Error) {
      emit(UserSendMessageErrorState());
    });
  }

  List<MessagesModel> message = [];

  void getMessages({
    required String receiverId,
  }) {
    FirebaseFirestore.instance
        .collection('user')
        .doc(userModel!.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('message').orderBy('dateTime')
        .snapshots().listen((event) {
      message=[];
      event.docs.reversed.forEach((element) {
        message.add(MessagesModel.fromJson(element.data()));
      });
      emit(GetMessageSuccessState());
    });
  }
  void logOut({ required BuildContext context, required Widget screen}){
emit(LogOutLoadingState());
    CachHelper.removeData(key: 'uId').then((value) {
      emit(LogOutSuccessState());
      NavigatorAndFinish(context: context, Widget: screen);
    }).catchError((Error){
      emit(LogOutErrorState());
    });
  }

  Future<void> dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('choose how do you sen this image'),
          content: Row(
            children: [
              Expanded(child  : IconButton(onPressed: (){

              }, icon: Icon(IconBroken.Camera,size: 35,))),
            //  SizedBox(w),
              Expanded(child: IconButton(onPressed: (){
                getChatImage().then((value) {
                 // Navigator.pop(context);
                });
              }, icon: Icon(Icons.add_circle_outline,size: 35))),
            ],
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: Text('Cancel',style: Theme.of(context).textTheme.bodyMedium,),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),

          ],
        );
      },
    );
  }
  File? chatImage;

  Future<void> getChatImage() async {
    final chatPickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (chatPickedFile != null) {
      chatImage = File(chatPickedFile.path);
      emit(GetChatImagePickedSuccessState());
    } else {
      print('Not image selected ');
      emit(GetUChatImagePickedErrorState());
    }
  }

  String chatImageUrl = '';

  void uploadChatImage({
    required String time,
    required String text,
  }) async {
    emit(UploadPostImageLoadingState());
    await FirebaseStorage.instance
        .ref()
        .child('chatImage/${Uri
        .file(chatImage!.path)
        .pathSegments
        .last
    }')
        .putFile(chatImage!)
        .then((vlaue) async {
      //print(vlaue.ref.getDownloadURL());
      chatImageUrl = await vlaue.ref.getDownloadURL();
      createPost(time: time, text: text, postImage: chatImageUrl);
      emit(UploadChatImageSuccessState());
    }).catchError((onError) {
      emit(UploadChatImageErrorState());
    });
  }


}

