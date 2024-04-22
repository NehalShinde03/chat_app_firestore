import 'package:chat_app_firestore/common/colors/common_colors.dart';
import 'package:chat_app_firestore/common/spacing/common_spacing.dart';
import 'package:chat_app_firestore/common/widget/enum.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'common_text.dart';

class BottomNavBar extends StatelessWidget {
  final BottomNavigationOption selectedTab;
  final ValueSetter<BottomNavigationOption> onTabChanged;

  const BottomNavBar({
    super.key,
    required this.selectedTab,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: CommonColor.black,
        height: kBottomNavigationBarHeight,
        // height: kBottomNavigationBarHeight + Spacing.xxLarge,
        padding: const EdgeInsets.only(top: Spacing.small),
        // decoration: const BoxDecoration(
        //   image: DecorationImage(
        //       image: AssetImage(AppImages.tabBar), fit: BoxFit.fill),
        // ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            BottomNavIcon(
              activeIcon: Icons.home,
              inactiveIcon: Icons.home,
              label: "Home",
              isSelected: selectedTab == BottomNavigationOption.home,
              value: BottomNavigationOption.home,
              onTabChanged: onTabChanged,
            ),
            BottomNavIcon(
              activeIcon: Icons.search,
              inactiveIcon: Icons.search,
              label: "Search",
              isSelected: selectedTab == BottomNavigationOption.search,
              value: BottomNavigationOption.search,
              onTabChanged: onTabChanged,
            ),
            BottomNavIcon(
              activeIcon: Icons.add,
              inactiveIcon: Icons.add,
              label: "New Post",
              isSelected: selectedTab == BottomNavigationOption.addPost,
              value: BottomNavigationOption.addPost,
              onTabChanged: onTabChanged,
            ),
            BottomNavIcon(
              activeIcon: Icons.person,
              inactiveIcon: Icons.person,
              label: "Profile",
              isSelected: selectedTab == BottomNavigationOption.profile,
              value: BottomNavigationOption.profile,
              onTabChanged: onTabChanged,
            ),
          ],
        ),
      ),
    );
  }
}

class BottomNavIcon extends StatelessWidget {
  final IconData? activeIcon;
  final IconData? inactiveIcon;
  final String label;
  final bool isSelected;
  final BottomNavigationOption value;
  final ValueSetter<BottomNavigationOption> onTabChanged;

  const BottomNavIcon({
    super.key,
    this.activeIcon,
    this.inactiveIcon,
    required this.label,
    required this.value,
    required this.isSelected,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: () => onTabChanged.call(value),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Icon(isSelected ? activeIcon : inactiveIcon,
            color: isSelected ? CommonColor.white : CommonColor.grey.withOpacity(0.7),),

          const Gap(6),
          CommonText(
            text: label,
            textColor: isSelected ? CommonColor.white : CommonColor.grey,
            fontSize: 12,
            fontWeight: FontWeight.w500,
            // letterSpacing: 0.8,
          )
        ],
      ),
    );
  }
}
