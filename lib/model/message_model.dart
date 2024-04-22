import 'package:json_annotation/json_annotation.dart';
part 'message_model.g.dart';

@JsonSerializable()
class MessageModel{

  final String messageId;
  final String conversationId;
  final String senderId;
  final String message;

  MessageModel({
    this.messageId = "",
    this.conversationId = "",
    this.senderId = "",
    this.message = "",
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) => _$MessageModelFromJson(json);

  Map<String, dynamic> toJson() => _$MessageModelToJson(this);

}