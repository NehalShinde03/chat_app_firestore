class ShowCommentNameModel{

  final String userName;
  final String comment;

  ShowCommentNameModel({
    this.userName = "",
    this.comment = "",
  });

  factory ShowCommentNameModel.fromJson(Map<String, dynamic> json) => ShowCommentNameModel(
      userName: json['userName'],
      comment: json['comment']
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'userName':userName,
    'comment':comment
  };

}