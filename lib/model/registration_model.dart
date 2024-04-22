class RegistrationModel {

  late final String? userId;
  late final String userName;
  late final String userEmail;
  late final String userPassword;
  late final String userConfirmPassword;

  RegistrationModel({
      this.userId = "",
      required this.userName,
      required this.userEmail,
      required this.userPassword,
      required this.userConfirmPassword});

  factory RegistrationModel.fromJson(Map<String, dynamic> json) => RegistrationModel(
      userId: json['userId'],
      userName: json['userName'],
      userEmail: json['userEmail'],
      userPassword: json['userPassword'],
      userConfirmPassword: json['userConfirmPassword'],
  );

  Map<String, dynamic> toJson() => {
    'userId' : userId,
    'userName' : userName,
    'userEmail' : userEmail,
    'userPassword' : userPassword,
    'userConfirmPassword' : userConfirmPassword
  };

}
