import 'package:chat_app_firestore/model/conversation_model.dart';
import 'package:chat_app_firestore/services/firebase_service.dart';
import 'package:chat_app_firestore/ui/message/message_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MessageCubit extends Cubit<MessageState> {
  MessageCubit(super.initialState) {
    readConversation();
    getSenderId();
  }

  /// read conversation and store in model
  void readConversation() async {
    ConversationModel conversationModel = await FirebaseServices.firebaseInstance.read();
    emit(state.copyWith(conversationModel: conversationModel));
    print("datasss -----> ${conversationModel.conversationId}");
  }

  // done
  void textFieldEmpty({bool? isTextFieldEmpty}) {
    emit(state.copyWith(isTextFieldEmpty: isTextFieldEmpty));
  }

  void getConversationId({required String conversationId}) async {
    emit(state.copyWith(conversationId: conversationId));
    print("conversation data ------> ${conversationId}");
  }

  void getSenderId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    emit(state.copyWith(senderId: preferences.getString('userId').toString()));
  }


  // void readMessage({required String messageId}) async {
  //   print("pass messageId ===> $messageId");
  //   final List<String> messageList = List<String>.from(
  //     await FirebaseServices.firebaseInstance.readMessage(messageId: messageId),
  //   );
  //   emit(state.copyWith(messageList: messageList));
  //   print("cubit message List ===> ${state.messageList.length}");
  // }
}
