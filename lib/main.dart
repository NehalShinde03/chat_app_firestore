// import 'package:msg/firebase_options.dart';
import 'package:chat_app_firestore/firebase_options.dart';
import 'package:chat_app_firestore/ui/all_post/all_post_ui.dart';
import 'package:chat_app_firestore/ui/all_user/all_user_ui.dart';
import 'package:chat_app_firestore/ui/bottom_nav_bar/bottom_nav_bar_view.dart';
import 'package:chat_app_firestore/ui/login/login_ui.dart';
import 'package:chat_app_firestore/ui/message/message_ui.dart';
import 'package:chat_app_firestore/ui/profle/profile_ui.dart';
import 'package:chat_app_firestore/ui/registration/registration_ui.dart';
import 'package:chat_app_firestore/ui/search_user_profile/search_user_profile_ui.dart';
import 'package:chat_app_firestore/ui/splash/splash_ui.dart';
import 'package:chat_app_firestore/ui/upload_post/upload_post_ui.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: SplashUi.routeName,
      // initialRoute: BottomNavBarView.routeName,
      routes: route,
    );
  }

  Map<String, WidgetBuilder> get route => {
    // BottomNavigationBarUi.routeName:BottomNavigationBarUi.builder,
    BottomNavBarView.routeName:BottomNavBarView.builder,
    SplashUi.routeName:SplashUi.builder,
    LoginUi.routeName:LoginUi.builder,
    RegistrationUi.routeName:RegistrationUi.builder,
    AllPostUi.routeName:AllPostUi.builder,
    SearchUserProfileUi.routeName:SearchUserProfileUi.builder,
    UploadPostUi.routeName:UploadPostUi.builder,
    ProfileUi.routeName:ProfileUi.builder,
    MessageUi.routeName:MessageUi.builder,
    AllUserUi.routeName:AllUserUi.builder,
  };

}