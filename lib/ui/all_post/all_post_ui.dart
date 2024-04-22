import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:chat_app_firestore/common/colors/common_colors.dart';
import 'package:chat_app_firestore/common/images/common_images.dart';
import 'package:chat_app_firestore/ui/all_user/all_user_ui.dart';

class AllPostUi extends StatefulWidget {
  const AllPostUi({super.key});

  static const String routeName = '/all_post_ui';
  static Widget builder(BuildContext context) => AllPostUi();

  @override
  State<AllPostUi> createState() => _AllPostUiState();
}

class _AllPostUiState extends State<AllPostUi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () => Navigator.pushNamed(context, AllUserUi.routeName),
              icon: SvgPicture.asset(CommonSvg.message, color: CommonColor.black,))
        ],
      ),
    );
  }
}
