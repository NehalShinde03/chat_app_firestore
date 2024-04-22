import 'package:equatable/equatable.dart';
import 'package:chat_app_firestore/common/widget/enum.dart';

class BottomNavBarState extends Equatable {
  ///for drop down
  final BottomNavigationOption navigationOption;

  const BottomNavBarState({
    required this.navigationOption,
  });

  @override
  List<Object?> get props => [navigationOption];

  BottomNavBarState copyWith({
    BottomNavigationOption? navigationOption,
  }) {
    return BottomNavBarState(
      navigationOption: navigationOption ?? this.navigationOption,
    );
  }
}
