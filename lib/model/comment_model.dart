class CommentModel{

  final String comment;
  final String commentId;
  final String userId;
  final String postId;

  CommentModel({
    this.comment = "",
    this.commentId = "",
    this.userId = "",
    this.postId = ""
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) => CommentModel(
      comment: json['comment'],
      commentId: json['commentId'],
      userId: json['userId'],
      postId: json['postId']
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'comment':comment,
    'commentId':commentId,
    'userId':userId,
    'postId':postId
  };

}