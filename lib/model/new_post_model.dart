class NewPostModel{

  final String postId;
  final String userId;
  final String imageUrl;
  final String description;
  final String location;
  final List<String> like;
  final List<String> comment;
  final bool isLike;

  NewPostModel({
    this.postId = "",
    this.userId = "",
    this.imageUrl = "",
    this.description = "",
    this.location = "",
    this.like = const [],
    this.comment = const [],
    this.isLike = false,
  });

  factory NewPostModel.fromJson(Map<String, dynamic> json) => NewPostModel(
    postId: json['postId'],
    userId: json['userId'],
    imageUrl: json['imageUrl'],
    description: json['description'],
    location: json['location'],
    like: json['like'],
    comment: json['comment'],
    isLike: json['isLike'],
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'postId':postId,
    'userId':userId,
    'imageUrl' : imageUrl,
    'description' : description,
    'location' : location,
    'like':like,
    'comment':comment,
    'isLike':isLike,
  };

}