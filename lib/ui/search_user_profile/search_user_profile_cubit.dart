import 'package:chat_app_firestore/services/firebase_service.dart';
import 'package:chat_app_firestore/ui/search_user_profile/search_user_profile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchUserProfileCubit extends Cubit<SearchUserProfileState>{
  SearchUserProfileCubit(super.initialState);

  void readAllImage() async{
    final List imageList= await FirebaseServices.firebaseInstance.fetchImage();
    emit(state.copyWith(imageList: imageList));
    print("image list called");
  }

  /// textfield onChange
  void isSearchUser({required bool isSearching}) async{
    emit(state.copyWith(isSearching: isSearching));
  }

  /// fetch userName during searching
  void searchingUserName({required String userEmail}){
    emit(state.copyWith(userEmail: userEmail));
    print("userName ===> ${state.userEmail}");
  }


  /// get match userName
 // void getUserName({required String userName}) async{
 //    final userNameList = await FirebaseServices.firebaseInstance.searchUserName(userName: userName.trim());
 //    emit(state.copyWith(userList:  userNameList));
 //    print("userName in List ===> ${state.userList}");
 // }

}

