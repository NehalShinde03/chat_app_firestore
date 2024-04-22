import 'package:chat_app_firestore/common/colors/common_colors.dart';
import 'package:chat_app_firestore/common/spacing/common_spacing.dart';
import 'package:chat_app_firestore/common/widget/common_text.dart';
import 'package:chat_app_firestore/services/firebase_service.dart';
import 'package:chat_app_firestore/ui/profle/profile_ui.dart';
import 'package:chat_app_firestore/ui/search_user_profile/search_user_profile_cubit.dart';
import 'package:chat_app_firestore/ui/search_user_profile/search_user_profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';

class SearchUserProfileUi extends StatefulWidget {
  const SearchUserProfileUi({super.key});

  static const String routeName = '/search_user_profile_ui';

  static Widget builder(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchUserProfileCubit(
        SearchUserProfileState(
            searchUserNameController: TextEditingController()),
      ),
      child: const SearchUserProfileUi(),
    );
  }

  @override
  State<SearchUserProfileUi> createState() => _SearchUserProfileUiState();
}

class _SearchUserProfileUiState extends State<SearchUserProfileUi> {
  SearchUserProfileCubit get cubit => context.read<SearchUserProfileCubit>();

  @override
  void initState() {
    super.initState();
    context.read<SearchUserProfileCubit>().readAllImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CommonColor.black.withOpacity(0.9),
      body: BlocBuilder<SearchUserProfileCubit, SearchUserProfileState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsetsDirectional.only(top: Spacing.xxLarge),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// search view
                Padding(
                  padding: const EdgeInsetsDirectional.symmetric(
                      horizontal: Spacing.small),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 19,
                    child: TextFormField(
                      controller: state.searchUserNameController,
                      onChanged: (val) {
                        if (val.isEmpty) {
                          cubit.isSearchUser(isSearching: false);
                        } else {
                          // cubit.getUserName(userName: val);
                          cubit.isSearchUser(isSearching: true);
                        }
                        cubit.searchingUserName(userEmail: val);
                      },
                      style: const TextStyle(color: CommonColor.grey),
                      cursorColor: CommonColor.grey.withOpacity(0.9),
                      cursorWidth: Spacing.xSmall - 1.7,
                      decoration: InputDecoration(
                        hintText: "Search User...",
                        filled: true,
                        fillColor: CommonColor.grey.withOpacity(0.2),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: CommonColor.grey,
                        ),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            state.searchUserNameController.clear();
                            cubit.isSearchUser(isSearching: false);
                          },
                          child: const Icon(
                            Icons.cancel_outlined,
                            color: CommonColor.grey,
                          ),
                        ),
                        hintStyle: const TextStyle(color: CommonColor.grey),
                        contentPadding: const EdgeInsetsDirectional.only(
                          start: Spacing.small,
                          bottom: Spacing.large,
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(Spacing.small),
                            borderSide:
                                const BorderSide(color: CommonColor.black)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(Spacing.small),
                            borderSide:
                                const BorderSide(color: CommonColor.black)),
                      ),
                    ),
                  ),
                ),

                /*
            state.isSearching == false ? list : image
            * */

                /// show all image
                Expanded(
                  child: RefreshIndicator(
                  onRefresh: () async {
                    await Future.delayed(const Duration(seconds: 1), () {
                      cubit.readAllImage();
                    });
                  },
                  child: state.isSearching
                      ? StreamBuilder(
                        stream: FirebaseServices.firebaseInstance.fireStoreRegisterUserInstance
                            .orderBy('userEmail').startAt([state.userEmail])
                            .endAt(["${state.userEmail}\uf8ff"]).snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              print("---> wait");
                              return Center(
                                child: Lottie.asset(
                                  "assets/animation/loading_animation.json",
                                  width: Spacing.xxxLarge * 4,
                                  height: Spacing.xxxLarge * 4,
                                  repeat: true,
                                ),
                              );
                            }
                            else if (snapshot.connectionState == ConnectionState.none) {
                              print("---> network issues");
                              return const CommonText(
                                text: "network issues",
                                textColor: CommonColor.white,
                              );
                            }
                            else {
                              if (!snapshot.hasData) {
                                print("---> no data");
                                return const CommonText(
                                  text: "no user found",
                                  textColor: CommonColor.white,
                                );
                              } else {
                                print("---> data loaded");
                                final data = snapshot.data?.docs;
                                return ListView.separated(
                                  shrinkWrap: true,
                                  itemCount: data?.length ?? 0,
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      onTap: ()  {
                                        print("userId ===> ${data?[index]['userId']}");
                                        Navigator.pushNamed(
                                          context, ProfileUi.routeName, arguments: data?[index]['userId']
                                        );
                                      },
                                      leading: const CircleAvatar(
                                        backgroundColor: Colors.grey,
                                        radius: 15,
                                      ),
                                      title: CommonText(
                                        // text: "${data?[index]['userEmail']}",
                                        text: "${data?[index]['userEmail']}",
                                        textAlign: TextAlign.start,
                                        textColor: CommonColor.white,
                                      ),
                                    );
                                  },
                                  separatorBuilder: (context, index) {
                                    return const Gap(Spacing.small);
                                  },
                                );
                              }
                            }
                          },
                         )
                        : state.imageList.isEmpty
                            ? Center(
                                child: Lottie.asset(
                                  "assets/animation/loading_animation.json",
                                  width: Spacing.xxxLarge * 4,
                                  height: Spacing.xxxLarge * 4,
                                  repeat: true,
                                ),
                              )
                            : GridView.builder(
                                shrinkWrap: true,
                                padding: PaddingValue.small,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: Spacing.small,
                                  mainAxisSpacing: Spacing.small,
                                ),
                                itemCount: state.imageList.length,
                                itemBuilder: (context, index) {
                                  print("image url ===> ${state.imageList[index]}");
                                  return Image.network(
                                    state.imageList[index],
                                    fit: BoxFit.fill,
                                  );
                                },
                              ),

                )),
              ],
            ),
          );
        },
      ),
    );
  }
}


/**/