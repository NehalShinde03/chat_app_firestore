import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class SearchUserProfileState extends Equatable{

  final List imageList;
  // final List userList;
  final bool isSearching;
  final String userEmail;
  final TextEditingController searchUserNameController;

  const SearchUserProfileState({
    this.imageList = const [],
    // this.userList = const [],
    this.isSearching = false,
    this.userEmail = "",
    required this.searchUserNameController
  });

  @override
  List<Object?> get props => [imageList, /*userList*/ isSearching, userEmail,searchUserNameController];

  SearchUserProfileState copyWith({
    List? imageList,
    List? userList,
    bool? isSearching,
    String? userEmail,
    TextEditingController? searchUserNameController
  }){
    return SearchUserProfileState(
        imageList: imageList ?? this.imageList,
        // userList: userList ?? this.userList,
        isSearching: isSearching ?? this.isSearching,
        userEmail: userEmail ?? this.userEmail,
        searchUserNameController: searchUserNameController ?? this.searchUserNameController
    );
  }

}