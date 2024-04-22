// import 'package:msg/common/images/common_images.dart';
// import 'package:msg/ui/all_post/all_post_ui.dart';
// import 'package:msg/ui/bottom_navigation_bar/bottom_navigation_bar_cubit.dart';
// import 'package:msg/ui/bottom_navigation_bar/bottom_navigation_bar_state.dart';
// import 'package:msg/ui/search_user_profile/search_user_profile_ui.dart';
// import 'package:msg/ui/upload_post/upload_post_ui.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import '../profle/profile_ui.dart';
//
// class BottomNavigationBarUi extends StatefulWidget {
//   const BottomNavigationBarUi({super.key});
//
//   static const String routeName = '/bottom_navigation_bar_ui';
//
//   static Widget builder(BuildContext context) => BlocProvider(
//         create: (context) => BottomNavigationBarCubit(BottomNavigationBarState(
//           pageController: PageController(initialPage: 0, keepPage: true),
//         )),
//         child: const BottomNavigationBarUi(),
//       );
//
//   @override
//   State<BottomNavigationBarUi> createState() => _BottomNavigationBarUiState();
// }
//
// class _BottomNavigationBarUiState extends State<BottomNavigationBarUi> {
//   BottomNavigationBarCubit get cubit => context.read<BottomNavigationBarCubit>();
//   final _screenList = [const AllPostUi(), const SearchUserProfileUi(), const UploadPostUi(), const ProfileUi()];
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<BottomNavigationBarCubit, BottomNavigationBarState>(
//       builder: (context, state) {
//         return Scaffold(
//           /*appBar: AppBar(
//             actions: [
//               IconButton(
//                   onPressed: () => Navigator.pushNamed(context, AllUserUi.routeName),
//                   icon: SvgPicture.asset(CommonSvg.message, color: CommonColor.black,))
//             ],
//           ),*/
//           body: _screenList[state.index],
//           bottomNavigationBar: SingleChildScrollView(
//             child: BottomNavigationBar(
//               type: BottomNavigationBarType.fixed,
//               backgroundColor: CupertinoColors.black,
//               elevation: 30,
//               items: <BottomNavigationBarItem>[
//                 BottomNavigationBarItem(
//                   icon: SvgPicture.asset(CommonSvg.inActiveHome),
//                   activeIcon: SvgPicture.asset(CommonSvg.activeHome),
//                   label: '',
//                 ),
//                 BottomNavigationBarItem(
//                   icon: SvgPicture.asset(CommonSvg.inActiveSearch),
//                   activeIcon: SvgPicture.asset(CommonSvg.activeSearch),
//                   label: '',
//                 ),
//                 BottomNavigationBarItem(
//                   icon: SvgPicture.asset(CommonSvg.inActiveAdd),
//                   activeIcon: SvgPicture.asset(CommonSvg.activeAdd),
//                   label: '',
//                 ),
//                 BottomNavigationBarItem(
//                   icon: SvgPicture.asset(CommonSvg.inActiveProfile),
//                   activeIcon: SvgPicture.asset(CommonSvg.activeProfile),
//                   label: '',
//                 ),
//               ],
//               currentIndex: state.index,
//               onTap: (index) {
//                 cubit.updateIndex(selectedIndex: index);
//               },
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
