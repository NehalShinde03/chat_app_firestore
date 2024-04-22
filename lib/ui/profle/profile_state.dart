import 'package:equatable/equatable.dart';
import 'package:chat_app_firestore/model/registration_model.dart';

class ProfileState extends Equatable{

  final String userName;
  final String userId;
  final int totalPost;
  final RegistrationModel? userData;

  const ProfileState({
      this.userName = "",
      this.userId = "",
      this.totalPost = 0,
      this.userData
  });

  @override
  List<Object?> get props => [userName, userId, totalPost, userData];

  ProfileState copyWith({
    String? userName,
    String? userId,
    int? totalPost,
    RegistrationModel? userData
  }){
    return ProfileState(
       userName: userName ?? this.userName,
       userId: userId ?? this.userId,
      totalPost: totalPost ?? this.totalPost,
      userData: userData ?? this.userData
    );
  }

}