import 'package:chat_app_firestore/ui/all_user/all_user_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AllUserCubit extends Cubit<AllUserState>{
  AllUserCubit(super.initialState){
    getUserId();
  }

  void getUserId() async{
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    emit(state.copyWith(userId: sharedPreferences.get('userId').toString()));
  }




}