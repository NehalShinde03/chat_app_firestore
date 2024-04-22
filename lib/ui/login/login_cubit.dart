import 'package:chat_app_firestore/ui/login/login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(super.initialState);

  void isPasswordVisible({isPasswordVisible}) {
    emit(state.copyWith(isPasswordVisible: isPasswordVisible));
  }
}
