import 'package:json_annotation/json_annotation.dart';
part 'message_conversationId_model.g.dart';

@JsonSerializable()
class MessageConversationIdModel {
  final String conversationId;
  final List<String> messages;
  final List<String> senderId;

  MessageConversationIdModel({
    this.conversationId = "",
    this.messages = const[],
    this.senderId = const[]
  });

  factory MessageConversationIdModel.fromJson(Map<String, dynamic> json) => _$MessageConversationIdModelFromJson(json);
  Map<String, dynamic> toJson() => _$MessageConversationIdModelToJson(this);

}
