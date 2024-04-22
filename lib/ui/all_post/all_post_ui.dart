import 'package:chat_app_firestore/common/spacing/common_spacing.dart';
import 'package:chat_app_firestore/common/widget/common_text.dart';
import 'package:chat_app_firestore/model/comment_model.dart';
import 'package:chat_app_firestore/services/firebase_service.dart';
import 'package:chat_app_firestore/ui/all_post/all_post_cubit.dart';
import 'package:chat_app_firestore/ui/all_post/all_post_state.dart';
import 'package:chat_app_firestore/ui/upload_post/upload_post_cubit.dart';
import 'package:chat_app_firestore/ui/upload_post/upload_post_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:chat_app_firestore/common/colors/common_colors.dart';
import 'package:chat_app_firestore/common/images/common_images.dart';
import 'package:chat_app_firestore/ui/all_user/all_user_ui.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';

class AllPostUi extends StatefulWidget {
  const AllPostUi({super.key});

  static const String routeName = '/all_post_ui';
  static Widget builder(BuildContext context) {
    final registerUserId = ModalRoute.of(context)?.settings.arguments as String?;
    return BlocProvider(
      create: (context) => AllPostCubit(AllPostState(
          registerUserId: registerUserId ?? "",
          commentController: TextEditingController()),
      ),
      child: const AllPostUi(),
    );
  }

  @override
  State<AllPostUi> createState() => _AllPostUiState();
}

class _AllPostUiState extends State<AllPostUi> {

  AllPostCubit get allPostCubit => context.read<AllPostCubit>();
  UploadPostCubit get uploadPost => context.read<UploadPostCubit>();

  @override
  void dispose() {
    allPostCubit.state.commentController.clear();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: CommonColor.black.withOpacity(0.9),
      appBar: AppBar(
        backgroundColor: CommonColor.black.withOpacity(0.9),
        title: const CommonText(
          text: 'Post',
          fontWeight: FontWeight.bold,
          fontSize: Spacing.large,
          textColor: CommonColor.white,
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(Spacing.xSmall),
          child: Container(
            color: CommonColor.black,
            height: Spacing.xSmall-2,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsetsDirectional.only(end: Spacing.small),
            child: GestureDetector(
                onTap: () => Navigator.pushNamed(context, AllUserUi.routeName),
                child: SvgPicture.asset(CommonSvg.message, color: CommonColor.white,),
            ),
          )
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseServices.firebaseInstance.fireStoreNewPostInstance.orderBy('imageUrl', descending: true).snapshots(),
        builder: (context, snapshot) {
          print("type of snaphot ===> ${snapshot.runtimeType}");
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          else if (snapshot.connectionState == ConnectionState.none) {
            return const Center(
              child: CommonText(
                  text: 'Connection Failed',
                  textColor: CommonColor.white,
                  fontSize: Spacing.medium),
            );
          }
          else if (!snapshot.hasData) {
            return const Center(
              child: CommonText(
                  text: 'No Data Available..!!!',
                  textColor: CommonColor.white,
                  fontSize: Spacing.medium,
              ),
            );
          }
          else {
            return Stack(
              children: [
                ListView.separated(
                  itemCount: snapshot.data?.docs.length ?? 0,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: PaddingValue.small,
                      child: Card(
                        elevation: 20,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// name and delete
                            Padding(
                              padding: const EdgeInsetsDirectional.symmetric(
                                horizontal: Spacing.xMedium,
                                vertical: Spacing.small,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const CircleAvatar(
                                        backgroundColor: Colors.black,
                                        radius: 20,
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          BlocBuilder<AllPostCubit, AllPostState>(
                                            builder: (context, state) {
                                              return Padding(
                                                padding: const EdgeInsetsDirectional.symmetric(
                                                  horizontal: Spacing.small,
                                                ),
                                                child: CommonText(
                                                  text: state.registerUserName,
                                                ),
                                              );
                                            },
                                          ),
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .symmetric(
                                              horizontal: Spacing.small,
                                            ),
                                            child: CommonText(
                                              text: snapshot.data?.docs[index]['location'],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  PopupMenuButton(
                                    icon: const Icon(
                                      Icons.more_horiz_outlined,
                                    ),
                                    itemBuilder: (context) => [
                                      const PopupMenuItem(
                                        value: 1,
                                        child: CommonText(text: 'Delete'),
                                      )
                                    ],
                                    onSelected: (value) {
                                      if (value == 1) {
                                        FirebaseServices.firebaseInstance.deletePost(
                                          postId: snapshot.data?.docs[index]['postId'],
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),

                            /// show picked photo
                            Center(
                              child: Container(
                                width: MediaQuery.of(context).size.width / 1,
                                height: MediaQuery.of(context).size.height / 2,
                                margin: const EdgeInsetsDirectional.symmetric(
                                    vertical: Spacing.medium,
                                    horizontal: RadiusValue.medium),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20)),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.network(
                                    snapshot.data?.docs[index].get('imageUrl'),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ),

                            /// like, comment, desc
                            Padding(
                              padding: const EdgeInsetsDirectional.symmetric(horizontal: Spacing.small),
                              child: Row(
                                children: [

                                  ///for like
                                  BlocBuilder<AllPostCubit, AllPostState>(
                                    builder: (context, state) {

                                      // if(snapshot.data?.docs[index].get('imageUrl').toString().isEmpty ?? ""){
                                      //   // print("")
                                      // }else{
                                      //
                                      // }
                                      // print("upload image runtype ====> ${snapshot.data?.docs.last.get('imageUrl')}");

                                      return IconButton(
                                        onPressed: () {
                                          allPostCubit.insertLikes(
                                              postId: snapshot.data?.docs[index]['postId'],
                                              userId: state.registerUserId
                                          );
                                        },
                                        icon: Icon(
                                          snapshot.data?.docs[index]['isLike']
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          color: Colors.red,
                                          size: Spacing.xxLarge,
                                        ),
                                      );
                                    },
                                  ),

                                  ///for comment
                                  IconButton(
                                    onPressed: () {

                                      context.read<AllPostCubit>().retrieveComment(postId: snapshot.data?.docs[index]['postId']);

                                      ///showModalBottom Sheet does not move along with keyboard
                                      showModalBottomSheet(
                                        isScrollControlled: true,
                                        useSafeArea: true,
                                        context: context,
                                        builder: (context2) {
                                          return BlocProvider.value(
                                            value: BlocProvider.of<AllPostCubit>(context),
                                            child: Padding(
                                              padding: MediaQuery.of(context).viewInsets,
                                              child: Container(
                                                height: MediaQuery.of(context).size.height/2,
                                                margin: EdgeInsetsDirectional.only(
                                                    bottom: MediaQuery.of(context2).viewInsets.bottom
                                                ),
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    const Gap(Spacing.small),
                                                    const CommonText(
                                                      text: "💬",
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: TextSize.appBarTitle,
                                                    ),


                                                    BlocBuilder<AllPostCubit, AllPostState>(
                                                      builder: (context, state){
                                                        print("comment List length view ===> ${state.commentList.length}");
                                                        return CommonText(
                                                          text: "${state.commentList.length} Comments",
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: TextSize.appBarTitle,
                                                        );
                                                      },
                                                    ),

                                                    const Gap(Spacing.medium),
                                                    BlocBuilder<AllPostCubit, AllPostState>(
                                                        builder: (context, state) {
                                                          return Padding(
                                                            padding: const EdgeInsetsDirectional.symmetric(horizontal: Spacing.small),
                                                            child: Row(
                                                              children: [
                                                                SizedBox(
                                                                  width: Spacing.xxxLarge * 7.0,
                                                                  child: Padding(
                                                                    padding: const EdgeInsetsDirectional.symmetric(horizontal: Spacing.small),
                                                                    child: TextFormField(
                                                                      controller: state.commentController,
                                                                      cursorColor: CommonColor.black,
                                                                      decoration: InputDecoration(
                                                                        hintText: "Type Something...",
                                                                        hintStyle: const TextStyle(
                                                                            color: CommonColor.black
                                                                        ),
                                                                        contentPadding: const EdgeInsetsDirectional.only(
                                                                          start: Spacing.small,
                                                                          bottom: Spacing.xxLarge,
                                                                        ),
                                                                        border: OutlineInputBorder(
                                                                            borderRadius: BorderRadius.circular(Spacing.large),
                                                                            borderSide: const BorderSide(color: CommonColor.black)
                                                                        ),
                                                                        focusedBorder: OutlineInputBorder(
                                                                            borderRadius: BorderRadius.circular(Spacing.large),
                                                                            borderSide: const BorderSide(color: CommonColor.black)
                                                                        ),
                                                                      ),
                                                                      onChanged: (val){
                                                                        (val.isNotEmpty)
                                                                            ? allPostCubit.textFieldTextChange(isTextFieldEmpty: true)
                                                                            : allPostCubit.textFieldTextChange(isTextFieldEmpty: false);
                                                                      },
                                                                    ),
                                                                  ),
                                                                ),
                                                                GestureDetector(
                                                                  behavior: HitTestBehavior.opaque,
                                                                  onTap: (state.isTextFieldEmpty)
                                                                      ? () {
                                                                    print("textEditingController ===> ${state.commentController.text}");
                                                                    allPostCubit.insertComment(
                                                                      commentModel: CommentModel(
                                                                        comment: state.commentController.text ,
                                                                        postId: snapshot.data?.docs[index]['postId'],
                                                                        userId: state.registerUserId,
                                                                      ),
                                                                      index: state.commentList.length,
                                                                    );
                                                                    state.commentController.value = const TextEditingValue(text: "");
                                                                    allPostCubit.textFieldTextChange(isTextFieldEmpty: false);
                                                                  } : null,
                                                                  child: const CircleAvatar(
                                                                    radius: 20,
                                                                    backgroundColor: Colors.white,
                                                                    child: Icon(Icons.telegram, size: Spacing.xxxLarge * 1.1),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        }),

                                                    const Gap(Spacing.medium),
                                                    Flexible(
                                                        child: BlocBuilder<AllPostCubit, AllPostState>(
                                                          builder: (context, state) {
                                                            print("comment List length view ===> ${state.commentList.length}");
                                                            if(state.commentList.isEmpty){
                                                              return const Center(child: CircularProgressIndicator(),);
                                                            }else{
                                                              return ListView.separated(
                                                                itemCount: state.commentList.length,
                                                                shrinkWrap: true,
                                                                reverse: true,
                                                                itemBuilder: (context, index) {
                                                                  return  SizedBox(
                                                                    child: Row(
                                                                      children: [
                                                                        const Padding(
                                                                          padding:
                                                                          EdgeInsetsDirectional
                                                                              .symmetric(horizontal: 5,vertical: 2),
                                                                          child: CircleAvatar(
                                                                            backgroundColor:Colors.black,
                                                                            radius: 15,
                                                                          ),
                                                                        ),

                                                                        Padding(
                                                                            padding: const EdgeInsetsDirectional.symmetric(horizontal:Spacing.small),
                                                                            child: Row(
                                                                              children: [
                                                                                CommonText(
                                                                                  text: state.commentList[index].userName,
                                                                                  textColor: Colors.black,
                                                                                  fontWeight:
                                                                                  FontWeight.bold,
                                                                                  fontSize: TextSize.appBarSubTitle,
                                                                                ),
                                                                                const Gap(Spacing.small),

                                                                                CommonText(
                                                                                  text: state.commentList[index].comment,
                                                                                  textColor: Colors.black,
                                                                                  fontWeight:
                                                                                  FontWeight.w400,
                                                                                  fontSize: TextSize.appBarSubTitle,
                                                                                ),
                                                                              ],
                                                                            )
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  );

                                                                },
                                                                separatorBuilder: (context, index) {
                                                                  return const Gap(Spacing.xSmall);
                                                                },
                                                              );
                                                            }
                                                          },
                                                        )
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.comment_outlined,
                                      color: Colors.black,
                                      size: Spacing.xLarge,
                                    ),
                                  )

                                ],
                              ),
                            ),

                            ///total number of likes   /// done
                            StreamBuilder<List<String>>(
                                stream: FirebaseServices.firebaseInstance.showUserNameToLikeAPost(
                                    postId: snapshot.data?.docs[index]['postId']
                                ).asStream(),
                                builder: (context, snapshot) {
                                  return GestureDetector(
                                    onTap: () {
                                      showModalBottomSheet(
                                        context: context,
                                        builder: (context) {
                                          return Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                            children: [
                                              const Gap(Spacing.small),
                                              const CommonText(
                                                text: "❤️",
                                                fontWeight: FontWeight.bold,
                                                fontSize: TextSize.appBarTitle,
                                              ),
                                              CommonText(
                                                text: '${snapshot.data?.length ?? 0} Likes',
                                                fontWeight: FontWeight.bold,
                                                fontSize: TextSize.label,
                                              ),
                                              const Gap(15),
                                              Flexible(
                                                child: ListView.separated(
                                                  itemCount: snapshot.data?.length ?? 0,
                                                  itemBuilder: (context, index) {
                                                    return Row(
                                                      children: [
                                                        const Padding(
                                                          padding:
                                                          EdgeInsetsDirectional
                                                              .symmetric(horizontal: 5,vertical: 2),
                                                          child: CircleAvatar(
                                                            backgroundColor:Colors.black,
                                                            radius: 15,
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                          const EdgeInsetsDirectional
                                                              .symmetric(
                                                              horizontal:Spacing.small),
                                                          child: CommonText(
                                                            text: snapshot.data?[index] ?? "",
                                                            textColor: Colors.black,
                                                            fontWeight:
                                                            FontWeight.bold,
                                                            fontSize: TextSize
                                                                .appBarSubTitle,
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                  separatorBuilder: (context, index) {
                                                    return const Gap(Spacing.xSmall);
                                                  },
                                                ),
                                              )
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: Padding(
                                        padding: const EdgeInsetsDirectional.only(
                                            start: Spacing.large,
                                            bottom: Spacing.xSmall),
                                        child: CommonText(
                                          text: '${snapshot.data?.length ?? 0} Likes',
                                          textColor: Colors.grey,
                                        )
                                    ),
                                  );
                                }
                            ),

                            /// description
                            Padding(
                              padding: const EdgeInsetsDirectional.symmetric(horizontal: Spacing.xLarge, vertical: Spacing.medium),
                              child: CommonText(
                                text: snapshot.data?.docs[index]['description'],
                                textColor: Colors.black,
                                fontWeight: TextWeight.semiBold,
                                fontSize: TextSize.label-2,
                                textAlign: TextAlign.start,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const Gap(Spacing.medium);
                  },
                ),
                
               /* BlocProvider(
                  create: (context) => UploadPostCubit(
                    UploadPostState(
                      descriptionController: TextEditingController(),
                      locationController: TextEditingController(),
                      pickedImageFile: XFile(""),
                    ),
                  ),
                child: BlocBuilder<UploadPostCubit, UploadPostState>(
                    builder: (context, state){
                      if(state.uploadImage.isEmpty){
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          color: CommonColor.black.withOpacity(0.9),
                          child: const Center(child: CircularProgressIndicator(),),
                        );
                      }else{
                        return const SizedBox();
                      }
                    }
                ),
              ),*/

              ],
            );
          }
        },
      ),
    );
  }
}
