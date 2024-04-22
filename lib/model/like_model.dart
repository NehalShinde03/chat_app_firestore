import 'package:cloud_firestore/cloud_firestore.dart';

class LikeModal {

  final String? likeId;
  final List<Map<String, dynamic>> postId;

  LikeModal({
    this.likeId = "",
    required this.postId,
  });

  factory LikeModal.fromJson(Map<String, dynamic> json) => LikeModal(
        likeId: json['likeId'],
        postId: List<Map<String, dynamic>>.from(json['postId'].map((e) => Users.fromJson(e))),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'likeId': likeId,
        'postId': postId
  };

}

class Users {
  final String? userId;
  Users({this.userId = ""});

  factory Users.fromJson(Map<String, dynamic> json) =>
      Users(
          userId: json['userId']
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'userId': userId,
      };
}


/*import 'package:cloud_firestore/cloud_firestore.dart';

class LikeModal {

  final String? likeId;
  final List<Map<String, Users>> postId;

  LikeModal({
    this.likeId = "",
    required this.postId,
  });

  factory LikeModal.fromJson(Map<String, dynamic> json) => LikeModal(
        likeId: json['likeId'],
        postId: json['postId'].map((key, value) => MapEntry(
                  key,
                  Users.fromJson(value)
        )),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'likeId': likeId,
        'postId': postId.map((key, value) => MapEntry(key, value.toJson()))
      };

}

class Users {
  final String? userId;
  Users({this.userId = ""});

  factory Users.fromJson(Map<String, dynamic> json) =>
      Users(
          userId: json['userId']
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'userId': userId,
      };
}


// class MyData {
//   final String id;
//   final Map<String, Lineup> lineup;
//   final String location;
//
//   MyData({required this.id, required this.lineup, required this.location});
//
//   factory MyData.fromFirestore(DocumentSnapshot snapshot) {
//     final data = snapshot.data() as Map<String, dynamic>;
//     return MyData(
//       id: data['id'] as String,
//       lineup: (data['lineup'] as Map<String, dynamic>).map((key, value) =>
//           MapEntry(
//             key,
//             Lineup.fromFirestore(
//                 FirebaseFirestore.instance.collection('lineup').doc(key) as DocumentSnapshot<Object?>),
//           )),
//       location: data['location'] as String,
//     );
//   }
// }
//
// class Lineup {
//   final String name;
//   final String trackId;
//
//   Lineup({required this.name, required this.trackId});
//
//   factory Lineup.fromFirestore(DocumentSnapshot snapshot) {
//     final data = snapshot.data() as Map<String, dynamic>;
//     return Lineup(
//       name: data['name'] as String,
//       trackId: data['trackId'] as String,
//     );
//   }
// }
*/