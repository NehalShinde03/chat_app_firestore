import 'package:chat_app_firestore/model/conversation_model.dart';
import 'package:chat_app_firestore/model/registration_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class MessageState extends Equatable {

  final bool isTextFieldEmpty;
  final TextEditingController messageController;
  final RegistrationModel? registrationModel;
  final ConversationModel? conversationModel;
  final String conversationId;
  final String senderId;
  final List<String> messageList;

  const MessageState({
    this.isTextFieldEmpty = true,
    required this.messageController,
    this.registrationModel,
    this.conversationModel,
    this.conversationId = "",
    this.senderId = "",
    this.messageList = const [],
  });

  @override
  List<Object?> get props => [
      isTextFieldEmpty,
      messageController,
      registrationModel,
      conversationModel,
      conversationId,
      senderId,
      messageList,
  ];

  MessageState copyWith(
      {
      bool? isTextFieldEmpty,
      TextEditingController? messageController,
      RegistrationModel? registrationModel,
      ConversationModel? conversationModel,
      String? conversationId,
      String? senderId,
      List<String>? messageList,
      }) {
    return MessageState(
        isTextFieldEmpty: isTextFieldEmpty ?? this.isTextFieldEmpty,
        messageController: messageController ?? this.messageController,
        registrationModel: registrationModel ?? this.registrationModel,
        conversationModel: conversationModel ?? this.conversationModel,
        conversationId: conversationId ?? this.conversationId,
        senderId: senderId ?? this.senderId,
        messageList: messageList ?? this.messageList
    );
  }
}
