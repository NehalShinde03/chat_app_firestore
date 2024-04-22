import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class LoginState extends Equatable {

  final TextEditingController emailController;
  final TextEditingController passWordController;
  final GlobalKey<FormState> formKey;
  final bool isPasswordVisible;

  //final int sizeOfCredentialMatches;
  final String registerUserId;


  const LoginState(
      {required this.emailController,
      required this.passWordController,
      required this.formKey,
      this.isPasswordVisible = false,
      this.registerUserId = ""
      //this.sizeOfCredentialMatches = 0,
      });

  @override
  List<Object?> get props => [
        emailController,
        passWordController,
        formKey,
        isPasswordVisible,
        registerUserId
        // sizeOfCredentialMatches
  ];

  LoginState copyWith(
      {TextEditingController? emailController,
      TextEditingController? passWordController,
      GlobalKey<FormState>? formKey,
      bool? isPasswordVisible,
      int? sizeOfCredentialMatches,
      String? registerUserId
      }) {
    return LoginState(
        emailController: emailController ?? this.emailController,
        passWordController: passWordController ?? this.passWordController,
        formKey: formKey ?? this.formKey,
        isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
        registerUserId: registerUserId ?? this.registerUserId
      // sizeOfCredentialMatches: sizeOfCredentialMatches ?? this.sizeOfCredentialMatches
    );
  }
}
