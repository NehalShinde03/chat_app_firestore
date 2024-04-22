import 'package:chat_app_firestore/common/colors/common_colors.dart';
import 'package:chat_app_firestore/common/images/common_images.dart';
import 'package:chat_app_firestore/common/spacing/common_spacing.dart';
import 'package:chat_app_firestore/common/widget/common_elevated_button.dart';
import 'package:chat_app_firestore/common/widget/common_text.dart';
import 'package:chat_app_firestore/ui/login/login_ui.dart';
import 'package:chat_app_firestore/ui/profle/profile_cubit.dart';
import 'package:chat_app_firestore/ui/profle/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileUi extends StatefulWidget {
  const ProfileUi({super.key});

  static const String routeName = '/profile_ui';

  static Widget builder(BuildContext context) {
    String? userId =
        (ModalRoute.of(context)?.settings.arguments ?? "") as String?;
    return BlocProvider(
      create: (context) => ProfileCubit(
        ProfileState(userId: userId ?? ""),
      ),
      child: const ProfileUi(),
    );
  }

  @override
  State<ProfileUi> createState() => _ProfileUiState();
}

class _ProfileUiState extends State<ProfileUi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CommonColor.black.withOpacity(0.9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          GestureDetector(
            onTap: () async {
              SharedPreferences sharedPreferences =
                  await SharedPreferences.getInstance();
              sharedPreferences.setString('userId', '');
              Navigator.pushNamedAndRemoveUntil(
                  context, LoginUi.routeName, (route) => false);
            },
            child: Padding(
              padding: const EdgeInsetsDirectional.only(end: Spacing.small),
              child: SvgPicture.asset(
                CommonSvg.logout,
              ),
            ),
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(Spacing.xLarge),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(Spacing.xxxLarge * 2),
                  child: Image.asset(
                    CommonJpg.profilePicture,
                    fit: BoxFit.cover,
                    width: Spacing.xxLarge * 5,
                    height: Spacing.xxLarge * 5,
                    scale: Spacing.small,
                  ),
                ),
                Column(
                  children: [
                    SizedBox(
                      child: CommonElevatedButton(
                        text: "Upload Image",
                        borderRadius: Spacing.small,
                        edgeInsetsDirectional:
                            const EdgeInsetsDirectional.symmetric(
                                horizontal: Spacing.small),
                        onPressed: () {},
                      ),
                    ),
                    const Gap(Spacing.medium),
                    SizedBox(
                      child: CommonElevatedButton(
                        text: "Set Default",
                        borderRadius: Spacing.small,
                        edgeInsetsDirectional:
                            const EdgeInsetsDirectional.symmetric(
                                horizontal: Spacing.small),
                        onPressed: () {},
                      ),
                    ),
                  ],
                )
              ],
            ),
            const Gap(Spacing.xLarge),
            BlocBuilder<ProfileCubit, ProfileState>(
              builder: (context, state) {
                // context.read<ProfileCubit>().fetchUserName(userId: state.userId);
                return Padding(
                  padding: const EdgeInsetsDirectional.symmetric(
                      horizontal: Spacing.xxxLarge * 2),
                  child: CommonText(
                    text: state.userName,
                    textColor: CommonColor.white,
                    fontWeight: FontWeight.bold,
                    fontSize: Spacing.large,
                    textAlign: TextAlign.start,
                  ),
                );
              },
            ),
            const Gap(Spacing.xLarge),
            BlocBuilder<ProfileCubit, ProfileState>(builder: (context, state) {
              return Padding(
                padding: EdgeInsetsDirectional.symmetric(
                    horizontal: Spacing.xxxLarge * 2),
                child: CommonText(
                  text: "Total uploaded Post : ${state.totalPost}",
                  textColor: CommonColor.grey,
                  fontWeight: FontWeight.w500,
                  fontSize: Spacing.medium + 6,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
