// import 'package:equatable/equatable.dart';
// import 'package:flutter/cupertino.dart';
//
// class BottomNavigationBarState extends Equatable{
//
//   final int index;
//   final PageController pageController;
//
//   const BottomNavigationBarState({
//     this.index = 0,
//     required this.pageController
//   });
//
//   @override
//   List<Object?> get props => [index, pageController];
//
//
//   BottomNavigationBarState copyWith({
//     int? index, PageController? pageController,
//   }){
//     return BottomNavigationBarState(
//         index: index ?? this.index,
//         pageController: pageController ?? this.pageController
//     );
//   }
//
// }