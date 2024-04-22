import 'package:equatable/equatable.dart';

class AllUserState extends Equatable{

  final String userId;

  const AllUserState({
    this.userId = ""
  });


  @override
  List<Object?> get props => [userId];

  AllUserState copyWith({
    String? userId
  }){
    return AllUserState(userId: userId ?? this.userId);
  }

}