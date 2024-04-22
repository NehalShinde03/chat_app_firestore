import 'package:chat_app_firestore/common/colors/common_colors.dart';
import 'package:chat_app_firestore/common/widget/common_text.dart';
import 'package:chat_app_firestore/model/message_model.dart';
import 'package:chat_app_firestore/model/registration_model.dart';
import 'package:chat_app_firestore/services/firebase_service.dart';
import 'package:chat_app_firestore/ui/message/message_cubit.dart';
import 'package:chat_app_firestore/ui/message/message_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

import '../../common/images/common_images.dart';
import '../../common/spacing/common_spacing.dart';

class MessageUi extends StatefulWidget {
  const MessageUi({super.key});

  static const String routeName = '/message_ui';

  static Widget builder(BuildContext context) {
    final arg = (ModalRoute.of(context)?.settings.arguments as RegistrationModel);
    return BlocProvider(
      create: (context) {
        return MessageCubit(MessageState(
          registrationModel: arg,
          messageController: TextEditingController(),
        ));
      },
      child: const MessageUi(),
    );
  }

  @override
  State<MessageUi> createState() => _MessageUiState();
}

class _MessageUiState extends State<MessageUi> {
  MessageCubit get cubit => context.read<MessageCubit>();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: SvgPicture.asset(
              CommonSvg.back,
              fit: BoxFit.scaleDown,
              color: Colors.black,
            ),
          ),
          title: BlocBuilder<MessageCubit, MessageState>(
            builder: (context, state) {
              print("userName on message screen =====> ${state.registrationModel?.userName}");
              return CommonText(
                text: state.registrationModel?.userName ?? "Unknown",
                fontWeight: FontWeight.bold,
                fontSize: Spacing.large,
              );
            },
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(Spacing.xSmall),
            child: Container(
              color: CommonColor.black,
              height: Spacing.xSmall-2,
            ),
          ),
        ),

        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.only(
                  bottom: Spacing.xLarge * 2.4,),
              child: SizedBox(
                child: StreamBuilder(
                    stream: FirebaseServices.firebaseInstance.readMessages(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      else if (snapshot.connectionState == ConnectionState.none) {
                        return const Center(
                          child: CommonText(text: "No chat Available...",),
                        );
                      }
                      else {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CommonText(
                              text: "Data Not Available",
                            ),
                          );
                        }
                        else {
                          print("snapshot conversation Id ==>>>>> ${snapshot.data?.conversationId}");
                          cubit.getConversationId(conversationId: snapshot.data?.conversationId ?? "");
                          // cubit.getConversationId(conversationId: snapshot.data?.conversationId ?? "");
                          return Padding(
                            padding: const EdgeInsetsDirectional.only(top: Spacing.medium),
                            child: ListView.separated(
                              itemCount: snapshot.data?.messages.length ?? 0,
                              shrinkWrap: true,
                              padding: PaddingValue.zero,
                              itemBuilder: (context, index) {
                                print('get id in cubit ===> ${cubit.state.senderId}');
                                print("snapshot sender id ====> ${snapshot.data?.senderId}");
                                return Align(
                                  alignment: cubit.state.senderId == snapshot.data?.senderId[index]
                                   ? Alignment.topRight
                                   : Alignment.topLeft,
                                  child: Container(
                                    margin: const EdgeInsetsDirectional.symmetric(
                                      horizontal: Spacing.xSmall
                                    ),
                                    padding:const EdgeInsetsDirectional.symmetric(
                                      vertical: Spacing.xSmall,
                                      horizontal: Spacing.small,
                                    ),
                                    decoration: BoxDecoration(
                                      color: (cubit.state.senderId == snapshot.data?.senderId[index]) ? CommonColor.black : CommonColor.white,
                                      border: Border.all(color: (cubit.state.senderId == snapshot.data?.senderId[index]) ? CommonColor.white : CommonColor.black,),
                                      borderRadius: BorderRadius.only(
                                        topLeft: const Radius.circular(20),
                                        topRight: const Radius.circular(20),
                                        bottomLeft: (cubit.state.senderId == snapshot.data?.senderId[index]) ? const Radius.circular(20) : const Radius.circular(5) ,
                                        bottomRight: (cubit.state.senderId == snapshot.data?.senderId[index]) ? const Radius.circular(5) : const Radius.circular(20),
                                      ),
                                    ),
                                    child: BlocBuilder<MessageCubit, MessageState>(
                                      builder: (context, state) {
                                        return CommonText(
                                          text: snapshot.data?.messages[index] ?? "",
                                          textColor: (cubit.state.senderId == snapshot.data?.senderId[index])
                                                      ? CommonColor.white : CommonColor.black,
                                        );
                                      },
                                    ),
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) {
                                return const Gap(Spacing.small);
                              },
                            ),
                          );
                        }
                      }
                    }),
              ),
            ),

            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding:
                    const EdgeInsetsDirectional.only(start: Spacing.xSmall),
                child: BlocBuilder<MessageCubit, MessageState>(
                  builder: (context, state) {
                    return Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 1.2,
                          child: TextFormField(
                            controller: state.messageController,
                            onChanged: (val) {
                              val.isNotEmpty
                                  ? cubit.textFieldEmpty(
                                      isTextFieldEmpty: false)
                                  : cubit.textFieldEmpty(
                                      isTextFieldEmpty: true);
                            },
                            cursorColor: CommonColor.black,
                            decoration: InputDecoration(
                              hintText: "Type Something...",
                              hintStyle: const TextStyle(color: CommonColor.grey),
                              contentPadding: const EdgeInsetsDirectional.only(
                                start: Spacing.small,
                                bottom: Spacing.xxLarge,
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(Spacing.large),
                                  borderSide: const BorderSide(color: CommonColor.black),),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(Spacing.large),
                                  borderSide: const BorderSide(
                                      color: CommonColor.black),),
                            ),
                          ),
                        ),
                        const Gap(Spacing.small),
                        GestureDetector(
                          onTap: state.isTextFieldEmpty
                              ? null
                              : () {
                                  print("message conversation Id ===> ${state.conversationModel?.conversationId}");
                                  FirebaseServices.firebaseInstance.addMessages(
                                    messageModel: MessageModel(
                                        message: state.messageController.text,
                                        conversationId: /*state.conversationModel?.conversationId ?? "",*/state.conversationId,
                                        senderId: state.senderId
                                    ),
                                  );
                                  state.messageController.text = "";
                                },
                          child: CircleAvatar(
                            radius: Spacing.xLarge,
                            backgroundColor: const Color(0xffD9E3F0),
                            child: SvgPicture.asset(CommonSvg.message),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
    );
  }
}
