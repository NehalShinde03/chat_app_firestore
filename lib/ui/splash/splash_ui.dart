import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:chat_app_firestore/common/colors/common_colors.dart';
import 'package:chat_app_firestore/common/images/common_images.dart';
import 'package:chat_app_firestore/common/spacing/common_spacing.dart';
import 'package:chat_app_firestore/common/widget/common_text.dart';
import 'package:chat_app_firestore/ui/bottom_nav_bar/bottom_nav_bar_view.dart';
import 'package:chat_app_firestore/ui/login/login_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashUi extends StatefulWidget {
  const SplashUi({super.key});

  static const String routeName = '/splash_ui';
  static Widget builder(BuildContext context) => const SplashUi();

  @override
  State<SplashUi> createState() => _SplashUiState();
}

class _SplashUiState extends State<SplashUi> {

  bool isEnter = false;
  @override
  void didChangeDependencies() async{
    super.didChangeDependencies();

    if(isEnter == false) {
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      Future.delayed(const Duration(seconds: 3), () {
        (sharedPreferences.getString('userId') ?? "").isEmpty
            ? Navigator.pushNamedAndRemoveUntil(context, LoginUi.routeName, (route) => false) //Navigator.pushNamed(context, LoginView.routeName)
            : Navigator.pushNamedAndRemoveUntil(context, BottomNavBarView.routeName, (route) => false);
      });
      isEnter = true;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CommonColor.black.withOpacity(0.9),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
                CommonSvg.splash,
                height: MediaQuery.of(context).size.height/8,
            ),
            const Gap(Spacing.large),
            const CommonText(
              text: "InstaFeed",
              textColor: CommonColor.white,
              fontSize: Spacing.xLarge,
              fontWeight: FontWeight.w500,
            )
          ],
        ),
      ),
    );
  }
}
