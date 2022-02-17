import 'user.dart';

class Post {
  int? id;
  String? body;
  String? image;
  int? likesCount;
  int? commentsCount;
  bool? selfLiked;
  User? user;

  Post({
    this.id,
    this.body,
    this.image,
    this.likesCount,
    this.commentsCount,
    this.selfLiked,
    this.user,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
        id: json['id'],
        body: json['body'],
        image: json['image'],
        likesCount: json['like_count'],
        commentsCount: json['comment_count'],
        selfLiked: json['like'].length > 0,
        user: User(
            id: json['user']['id'],
            name: json['user']['name'],
            image: json['user']['image']));
  }
  @override
  toString() => 'post: $body ' 'image:$image ' 'user:${user!.id} ';
}
