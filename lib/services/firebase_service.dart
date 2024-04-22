import 'dart:async';
import 'dart:io';

import 'package:chat_app_firestore/common/spacing/common_spacing.dart';
import 'package:chat_app_firestore/common/widget/common_text.dart';
import 'package:chat_app_firestore/model/comment_model.dart';
import 'package:chat_app_firestore/model/conversation_model.dart';
import 'package:chat_app_firestore/model/message_conversationId_model.dart';
import 'package:chat_app_firestore/model/message_model.dart';
import 'package:chat_app_firestore/model/new_post_model.dart';
import 'package:chat_app_firestore/model/registration_model.dart';
import 'package:chat_app_firestore/model/show_comment_name_model.dart';
import 'package:chat_app_firestore/ui/all_post/all_post_ui.dart';
import 'package:chat_app_firestore/ui/bottom_nav_bar/bottom_nav_bar_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseServices {

  static FirebaseServices firebaseInstance = FirebaseServices._();

  FirebaseServices._();

  final fireStoreRegisterUserInstance =
  FirebaseFirestore.instance.collection("RegisterUer");

  final fireStoreNewPostInstance =
  FirebaseFirestore.instance.collection("New Post");

  final fireStoreLikeInstance =
  FirebaseFirestore.instance.collection("Like");

  final fireStoreCommentInstance =
  FirebaseFirestore.instance.collection("Comment");

  final fireStoreConversationInstance =
  FirebaseFirestore.instance.collection("Conversation");

  final fireStoreMessageInstance =
  FirebaseFirestore.instance.collection("Message");

  String conversationId = "";

  /// compare sign-in user record with fireStore all user data
  void compareSignInRecordWithAllUser({ required String userEmail, required String userPassword, context,}) async {
    fireStoreRegisterUserInstance.where(Filter.and(
      Filter('userEmail', isEqualTo: userEmail),
      Filter('userPassword', isEqualTo: userPassword),
    )).get().then((value){
      if(value.size > 0){
        String userId = '';
        value.docs.forEach((element) {
          userId = element.get('userId');
        });
        Navigator.pushNamed(context, AllPostUi.routeName, arguments: userId);
      }else{
        MotionToast.error(
          toastDuration: const Duration(seconds: 3),
          title: const CommonText(
              text: 'Login',
              fontSize: Spacing.normal,
              fontWeight: TextWeight.bold),
          description: const CommonText(
            text: 'InValid Credential..!!!',
          ),
          barrierColor: Colors.black.withOpacity(0.3),
          dismissable: true,
          animationType: AnimationType.fromLeft,
          animationCurve: Curves.bounceOut,
          iconType: IconType.cupertino,
        ).show(context);
      }
    });
  }


  ///insert new user record in fireStore (collection name = 'RegisterUser')
  void insertNewUser({required RegistrationModel registrationModel}) async {
    await fireStoreRegisterUserInstance
        .add(registrationModel.toJson())
        .then((value) {
      value.set({'userId': value.id}, SetOptions(merge: true));
    });
  }


  /// insert description, location on post
  void insertNewPost({required NewPostModel newPostModel}) async {
    await fireStoreNewPostInstance.add(newPostModel.toJson()).then((value) {
      value.set({'postId': value.id}, SetOptions(merge: true));
    });
  }


  /// update like on post
  void updateLike({required String postId, required bool isLike}) async{
    await fireStoreNewPostInstance.doc(postId).update({'isLike' : isLike});
  }

  /// picked image from gallery
  Future<XFile?> imagePicker() async {
    return await ImagePicker().pickImage(source: ImageSource.gallery);
  }

  /// upload image
  Future<String> uploadImages({required XFile uploadImagePath, context}) async {
    if (uploadImagePath.path.isNotEmpty) {
      try {
        Reference reference = FirebaseStorage.instance.ref().child('Images/').child(uploadImagePath.name);
        var uploadImage = await reference.putFile(File(uploadImagePath.path));
        String downloadImageUrl = await uploadImage.ref.getDownloadURL();
        print('upload image type ===> ${uploadImage.runtimeType}');
        return downloadImageUrl;
      } catch (e) {
        print('Exception ====> $e');
      }
    }
    return "";
  }

  ///delete post
  void deletePost({required String postId}) {
    fireStoreNewPostInstance.doc(postId).delete();
  }

  /// get register user name
  Future<String> registerUserName({required String userId}) async {
    DocumentSnapshot<Map<String, dynamic>> userName = await fireStoreRegisterUserInstance.doc(userId).get();
    return userName.get('userName');
  }


  ///insert Like in newPost Collection
  Future<bool> insertLikes({required String postId, required String userId}) async{
    bool userAlreadyLikeOnPost = false;
    fireStoreNewPostInstance.doc().get();
    await fireStoreNewPostInstance.where(Filter.and(
      Filter('postId', isEqualTo: postId),
      Filter('like', arrayContains: userId),
    )).get().then((value){
      if(value.size > 0){
        fireStoreNewPostInstance.doc(postId).update({"like" : FieldValue.arrayRemove([userId])});
        userAlreadyLikeOnPost = false;
      }
      else{
        fireStoreNewPostInstance.doc(postId).update({"like" : FieldValue.arrayUnion([userId])});
        userAlreadyLikeOnPost = true;
      }
    });
    return userAlreadyLikeOnPost;
  }

  /// show users name to like a post
  Future<List<String>> showUserNameToLikeAPost({required String postId}) async{
    List<String> totalListList = [];
    DocumentSnapshot<Map<String, dynamic>> getPostData = await fireStoreNewPostInstance.doc(postId).get();
    List<String> getAllUserToBeLikeAPost  = List<String>.from(getPostData.get('like'));
    for(int i=0; i<getAllUserToBeLikeAPost.length; i++){
      DocumentSnapshot<Map<String, dynamic>> getUseData = await fireStoreRegisterUserInstance.doc(getAllUserToBeLikeAPost[i]).get();
      totalListList.add(getUseData.get('userName'));
    }
    return totalListList;
  }


  /// insert comment data
  Future<void> insertComment({required CommentModel commentModel}) async {
    await fireStoreCommentInstance.add(commentModel.toJson())
        .then((value) async {
      value.set({'commentId': value.id}, SetOptions(merge: true));
      await fireStoreNewPostInstance.doc(commentModel.postId).update({
        'comment': FieldValue.arrayUnion([value.id])
      });
    });
  }

  /// getComments
  Future<List<ShowCommentNameModel>> getComments({required String postId}) async {
    try {
      final postData = await fireStoreNewPostInstance.doc(postId).get();
      final List<String> commentIds = List<String>.from(postData.get('comment') ?? <String>[]);

      final List<DocumentSnapshot> commentSnapshots =
      await Future.wait(commentIds.map((commentId) => fireStoreCommentInstance.doc(commentId).get()));

      final List<ShowCommentNameModel> comments = [];

      for (final commentSnapshot in commentSnapshots) {
        final getUserId = commentSnapshot.get('userId');
        final getUserName = await fireStoreRegisterUserInstance.doc(getUserId).get();

        comments.add(ShowCommentNameModel(
          comment: commentSnapshot.get('comment'),
          userName: getUserName.get('userName'),
        ));
      }
      return comments;
    } catch (e) {
      rethrow;
    }
  }














  ///--------------------------------------/////
  /// fetch all image
  Future<List<String>> fetchImage() async {
    final download = FirebaseStorage.instance.ref().child('Images');
    final ListResult listResult = await download.listAll();

    /// convert Future<List<Future<String>>> to List<String>
    final List<String> imageList = await Future.wait(
        listResult.items.map((e) => e.getDownloadURL()).toList());
    print("list of image => ${imageList}");
    imageList.shuffle();
    return imageList;
  }

  /// fetch userName by Id
  Future<String> fetchUserName({required String userId}) async {
    final userData = await fireStoreRegisterUserInstance.doc(userId).get();
    return userData.get('userName');
  }


  /// calculate total post
  Future<int> totalPost({required String userId}) async {
    final data = await fireStoreNewPostInstance.where(
        'userId', isEqualTo: userId,
    ).get();
    return data.size;
  }

  /// check if conversation available
  void checkConversationAvailable({required ConversationModel conversationModel,}) async {
   final data = await fireStoreConversationInstance.where(
      Filter.or(
        Filter.and(
          Filter('senderId', isEqualTo: conversationModel.senderId),
          Filter('receiverId', isEqualTo: conversationModel.receiverId),
        ),
        Filter.and(
          Filter('senderId', isEqualTo:conversationModel.receiverId),
          Filter('receiverId', isEqualTo: conversationModel.senderId),
        ),
      )
    ).get();

    if (data.size > 0) {
      conversationId = data.docs.map((e) => e.get('conversationId')).toString();
      conversationId = conversationId.substring(1, conversationId.length - 1);
      print("enter if");
      print("conversation Iddsss => $conversationId");
    } else {
      addConversation(conversationModel: conversationModel);
      print("enter else");
    }
  }

  /// insert conversation
  void addConversation({required ConversationModel conversationModel}) {
    fireStoreConversationInstance.add(conversationModel.toJson()).then((value) {
      value.set({'conversationId': value.id}, SetOptions(merge: true));
      conversationId = value.id;
      print("conversation Iddsss => $conversationId");
    });
  }

  /// insert messages
  void addMessages({required MessageModel messageModel}) async {
    print("message ===>>> ${messageModel.message}");
    print("conversation ID ===>>> ${messageModel.conversationId}");
    fireStoreMessageInstance.add(messageModel.toJson()).then((value) async {
      value.set({"messageId": value.id}, SetOptions(merge: true));
      await fireStoreConversationInstance.doc(messageModel.conversationId).update({
        'messagesId': FieldValue.arrayUnion([value.id])
      });
    });
  }

  /// read conversation model
  Future<ConversationModel> read() async {
    final data = await fireStoreConversationInstance.orderBy(
        'conversationId', descending: true).limit(1).get();
    return ConversationModel.fromJson(data.docs[0].data());
  }

  /// read messages
  Stream<MessageConversationIdModel> readMessages() {
    print("conversation Id =>>> $conversationId");
    return fireStoreConversationInstance.doc(conversationId).snapshots().asyncMap((event) async {
      List<String> messageList = [];
      List<String> senderIdList = [];
      List<Future> futures = [];

      for (var messageId in event.data()?['messagesId']) {
        Future future = fireStoreMessageInstance.doc(messageId).get();
        futures.add(future);
      }

      await Future.wait(futures);

      for (var future in futures) {
        var element = await future;
        print("message list len ====> ${element.data()?['message']}");
        messageList.add(element.data()?['message']);
        senderIdList.add(element.data()?['senderId']);
      }

      print("messageList length ====> ${messageList.length}");
      return MessageConversationIdModel.fromJson({
        'conversationId': conversationId,
        'messages': messageList,
        'senderId' : senderIdList
      }); // Return the parsed model
    });
  }

}
