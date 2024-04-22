import 'package:chat_app_firestore/model/show_comment_name_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class AllPostState extends Equatable {
  final String registerUserId;
  final String registerUserName;
  final bool isLike;
  final int totalLikesOnPost;
  final List likePostList;
  final bool isImageUploaded;

  final int index;

  final TextEditingController commentController;
  final List<ShowCommentNameModel> commentList;
  final bool isTextFieldEmpty;
  // final Map<String, dynamic> commentData;

  const AllPostState({
    this.registerUserId = "",
    this.registerUserName = "",
    this.isLike = false,
    this.totalLikesOnPost = 0,
    this.likePostList = const [],
    this.isImageUploaded = false,
    required this.commentController,
    this.commentList = const <ShowCommentNameModel>[],
    this.index = 0,
    this.isTextFieldEmpty = false
    // this.commentData = const {}
  });

  @override
  List<Object?> get props => [
    registerUserId,
    registerUserName,
    isLike,
    totalLikesOnPost,
    likePostList,
    isImageUploaded,
    commentController,
    commentList,
    index,
    isTextFieldEmpty
    // commentData
  ];

  AllPostState copyWith({
    String? registerUserId,
    String? registerUserName,
    bool? isLike,
    int? totalLikesOnPost,
    List? likePostList,
    bool? isImageUploaded,
    TextEditingController? commentController,
    List<ShowCommentNameModel>? commentList,
    int? index,
    bool? isTextFieldEmpty,
    // Map<String, dynamic>? commentData,
  }) {
    return AllPostState(
        registerUserId: registerUserId ?? this.registerUserId,
        registerUserName: registerUserName ?? this.registerUserName,
        isLike: isLike ?? this.isLike,
        totalLikesOnPost: totalLikesOnPost ?? this.totalLikesOnPost,
        likePostList: likePostList ?? this.likePostList,
        isImageUploaded: isImageUploaded ?? this.isImageUploaded,
        commentController: commentController ?? this.commentController,
        commentList: commentList ?? this.commentList,
        // commentData: commentData ?? this.commentData,
        index: index ?? this.index,
        isTextFieldEmpty: isTextFieldEmpty ?? this.isTextFieldEmpty
    );
  }
}
