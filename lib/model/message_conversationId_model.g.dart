// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_conversationId_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageConversationIdModel _$MessageConversationIdModelFromJson(
        Map<String, dynamic> json) =>
    MessageConversationIdModel(
      conversationId: json['conversationId'] as String? ?? "",
      messages: (json['messages'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      senderId: (json['senderId'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$MessageConversationIdModelToJson(
        MessageConversationIdModel instance) =>
    <String, dynamic>{
      'conversationId': instance.conversationId,
      'messages': instance.messages,
      'senderId': instance.senderId,
    };
