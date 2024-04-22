import 'package:json_annotation/json_annotation.dart';
part 'conversation_model.g.dart';

@JsonSerializable()
class ConversationModel {
  final String conversationId;
  final String senderId;
  final String receiverId;
  final List<String> messagesId;

  ConversationModel({
    this.conversationId = "",
    this.senderId = "",
    this.receiverId = "",
    this.messagesId = const[]
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) => _$ConversationModelFromJson(json);
  Map<String, dynamic> toJson() => _$ConversationModelToJson(this);

}
