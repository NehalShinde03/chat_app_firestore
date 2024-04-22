import 'package:equatable/equatable.dart';

class MainDataState extends Equatable{

  final String userId;


  const MainDataState({
    required this.userId,
  });

  @override
  List<Object?> get props => [userId];

  MainDataState copyWith({String? userId}){
    return MainDataState(userId: userId ?? this.userId);
  }

}