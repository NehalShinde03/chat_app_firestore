import 'dart:async';

import 'package:chat_app_firestore/common/spacing/common_spacing.dart';
import 'package:chat_app_firestore/common/widget/common_text.dart';
import 'package:chat_app_firestore/model/conversation_model.dart';
import 'package:chat_app_firestore/model/message_conversationId_model.dart';
import 'package:chat_app_firestore/model/message_model.dart';
import 'package:chat_app_firestore/ui/bottom_nav_bar/bottom_nav_bar_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
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

  // List<String> messageList = [];
  String conversationId = "";


  void compareSignInRecordWithAllUser({required String userEmail,
    required String userPassword,
    context,}) async {
    fireStoreRegisterUserInstance
        .where('userEmail', isEqualTo: userEmail)
        .where('userPassword', isEqualTo: userPassword)
        .snapshots()
        .listen((snapshot) async {
      if (snapshot.size > 0) {
        SharedPreferences sharedPreferences = await SharedPreferences
            .getInstance();
        snapshot.docs.forEach((element) {
          sharedPreferences.setString('userId', element.get('userId'));
          Navigator.pushNamedAndRemoveUntil(
              context, BottomNavBarView.routeName, (route) => false);
        });
      } else {
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
        'userId', isEqualTo: userId).get();
    return data.size;
  }

  /// check if conversation available
  void checkConversationAvailable({required ConversationModel conversationModel,}) async {
    // final data = await fireStoreConversationInstance
    //     .where('senderId', isEqualTo: conversationModel.senderId,)
    //     .where('receiverId', isEqualTo: conversationModel.receiverId).get();

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
      // conversationId = conversationId.substring(1, conversationId.length - 1);
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

  // Future<List<String>> readMessage({required String messageId}) async {
  //   // List<String> messageList = [];
  //   final messageDoc = await fireStoreMessageInstance.doc(messageId).get();
  //   messageList.add(messageDoc.get('message'));
  //   return messageList;
  // }

  /// read conversation model
  Future<ConversationModel> read() async {
    final data = await fireStoreConversationInstance.orderBy(
        'conversationId', descending: true).limit(1).get();
    return ConversationModel.fromJson(data.docs[0].data());
  }


  /// read messages

  Stream<MessageConversationIdModel> readMessages() {
    // String cid = conversationId;
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
