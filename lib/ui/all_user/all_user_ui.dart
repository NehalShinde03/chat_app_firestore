import 'package:chat_app_firestore/common/images/common_images.dart';
import 'package:chat_app_firestore/common/spacing/common_spacing.dart';
import 'package:chat_app_firestore/common/widget/common_text.dart';
import 'package:chat_app_firestore/model/conversation_model.dart';
import 'package:chat_app_firestore/model/registration_model.dart';
import 'package:chat_app_firestore/services/firebase_service.dart';
import 'package:chat_app_firestore/ui/all_user/all_user_cubit.dart';
import 'package:chat_app_firestore/ui/all_user/all_user_state.dart';
import 'package:chat_app_firestore/ui/message/message_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import '../../common/colors/common_colors.dart';

class AllUserUi extends StatefulWidget {
  const AllUserUi({super.key});

  static const String routeName = '/chat_ui';

  static Widget builder(BuildContext context) => BlocProvider(
        create: (context) => AllUserCubit(const AllUserState()),
        child: const AllUserUi(),
      );

  @override
  State<AllUserUi> createState() => _AllUserUiState();
}

class _AllUserUiState extends State<AllUserUi> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CommonColor.black.withOpacity(0.9),
      appBar: AppBar(
        backgroundColor: CommonColor.black.withOpacity(0.9),
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: SvgPicture.asset(
            CommonSvg.back,
            fit: BoxFit.scaleDown,
            // color: Colors.black,
          ),
        ),
        title: const CommonText(
          text: "Chat",
          fontWeight: FontWeight.bold,
          fontSize: Spacing.xLarge,
          textColor: CommonColor.white,
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(Spacing.xSmall),
          child: Container(
            color: CommonColor.white,
            height: Spacing.xSmall-2,
          ),
        ),
      ),
      body: BlocBuilder<AllUserCubit, AllUserState>(
      builder: (context, state) {
        return StreamBuilder(
        stream: FirebaseServices.firebaseInstance.fireStoreRegisterUserInstance
                .where('userId', isNotEqualTo: state.userId).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          else if (snapshot.connectionState == ConnectionState.none) {
            return const SizedBox();
          }
          else {
            if (!snapshot.hasData) {
              return const Center(child: CommonText(text: "User Not available",),);
            }
            else {
              return Padding(
                padding: const EdgeInsetsDirectional.only(top: Spacing.medium),
                child: ListView.separated(
                  itemCount: snapshot.data?.docs.length ?? 0,
                  itemBuilder: (context, index){
                    print("all user index ----> $index");
                    print("user names ==> ${snapshot.data?.docs[index]["userId"]}");
                    return ListTile(
                      onTap: (){

                        print("sender Id ===> ${state.userId}");
                        print("receiver Id ===> ${snapshot.data?.docs[index]["userId"]}");

                        /// check conversation already created or not
                        FirebaseServices.firebaseInstance.checkConversationAvailable(
                          conversationModel: ConversationModel(
                              senderId: state.userId,
                              receiverId: snapshot.data?.docs[index]["userId"]
                          )
                        );
                        print("userName =---> ${snapshot.data?.docs[index].data()['userName']}");
                        Future.delayed(const Duration(seconds: 2),(){
                          Navigator.pushNamed(context, MessageUi.routeName, arguments: RegistrationModel.fromJson(snapshot.data?.docs[index].data() ?? {}));
                        });
                      },
                      tileColor: CommonColor.black,
                      leading: const CircleAvatar(
                        radius: Spacing.medium+3,
                        backgroundColor: CommonColor.grey,
                      ),
                      title: CommonText(text: snapshot.data?.docs[index]["userName"],
                        textAlign: TextAlign.start,
                        textColor: CommonColor.white,
                        fontWeight: FontWeight.bold,
                        fontSize: Spacing.large-3,
                      ),
                    );
                  },
                  separatorBuilder: (context, index){
                    return const Gap(5.5);
                  },
                ),
              );
            }
          }
        },
      );
  },
),
    );
  }
}
