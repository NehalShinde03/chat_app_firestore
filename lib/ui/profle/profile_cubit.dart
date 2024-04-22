import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chat_app_firestore/services/firebase_service.dart';
import 'package:chat_app_firestore/ui/profle/profile_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileCubit extends Cubit<ProfileState>{
  ProfileCubit(super.initialState){
    updateId();
  }

  /// update state id
  void updateId() async{
    print("state user Id ====> ${state.userId}");
    if(state.userId.isEmpty){
      SharedPreferences preferences = await SharedPreferences.getInstance();
      print("preference user Id ===> ${preferences.getString('UserId')}");
      emit(state.copyWith(userId: preferences.getString('userId').toString()));
    }else{
      print("enter else");
      emit(state.copyWith(userId: state.userId));
    }
    print("new user Id ==> ${state.userId}");
    fetchUserName(userId: state.userId);
    totalPost(userId: state.userId);
  }


  /// fetch userName
  void fetchUserName({required String userId}) async{
    final userName = await FirebaseServices.firebaseInstance.fetchUserName(userId: userId);
    emit(state.copyWith(userName: userName));
    print("UserName ===> ${state.userName}");
  }

  /// calculate total post
  void totalPost({required String userId}) async{
    final dataSize = await FirebaseServices.firebaseInstance.totalPost(userId: userId);
    emit(state.copyWith(totalPost: dataSize));
    print("total count --- ${state.totalPost}");
  }
}



/// upload image and set default tap action