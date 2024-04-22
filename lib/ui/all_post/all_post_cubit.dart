import 'package:chat_app_firestore/model/comment_model.dart';
import 'package:chat_app_firestore/model/show_comment_name_model.dart';
import 'package:chat_app_firestore/services/firebase_service.dart';
import 'package:chat_app_firestore/ui/all_post/all_post_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AllPostCubit extends Cubit<AllPostState> {
  AllPostCubit(super.initialState);


  /// text field data change
  void textFieldTextChange({required bool isTextFieldEmpty}){
    emit(state.copyWith(isTextFieldEmpty: isTextFieldEmpty));
  }

  /// insert like
  void insertLikes({required String userId, required String postId}) async {
    bool isLike = await FirebaseServices.firebaseInstance
        .insertLikes(postId: postId, userId: userId);
    FirebaseServices.firebaseInstance.updateLike(postId: postId, isLike: isLike);
    emit(state.copyWith(isLike: isLike));
  }

  /// insert comment
  void insertComment({required CommentModel commentModel, required int index,}) async{
    try{
      FirebaseServices.firebaseInstance.insertComment(commentModel: commentModel,);
    }catch(e){
      throw "Exception(insert Comment) ==> $e";
    }
    final getUserModel = await FirebaseServices.firebaseInstance.fireStoreRegisterUserInstance.doc(commentModel.userId).get();
    List<ShowCommentNameModel> commentList = state.commentList;
    commentList.add(ShowCommentNameModel(
        comment: commentModel.comment,
        userName: getUserModel.get('userName')
    ));
    emit(state.copyWith(commentList: commentList, index: state.commentList.length));
    print("state dataList length ==> ${state.commentList.length}");
  }

  /// retrieve list of comments
  void retrieveComment({required String postId}) async{
    emit(state.copyWith(commentList: <ShowCommentNameModel>[], index: 0));
    try{
      final List<ShowCommentNameModel> commentList = await FirebaseServices.firebaseInstance.getComments(postId: postId);
      emit(state.copyWith(commentList: commentList));
    }catch(e){
      throw "Exception(get Comment) ==> $e";
    }
  }

  /// upload image
  // void imageUpload({required XFile uploadImagePath, required bool isImageUploaded, required BuildContext context}) async{
  //   String uploadedImage = await FirebaseServices.firebaseInstance.uploadImages(uploadImagePath: uploadImagePath, context: context);
  //   emit(state.copyWith(uploadImage: uploadedImage, isImageUploaded: isImageUploaded));
  // }


}
