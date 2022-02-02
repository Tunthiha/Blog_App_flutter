import 'package:flutter/foundation.dart';

import 'user.dart';

class Post {
  int? id;
  String? body;
  String? image;
  User? user;

  Post({
    this.id,
    this.body,
    this.image,
    this.user,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
        id: json['id'],
        body: json['body'],
        image: json['image'],
        user: User(
          id: json['user']['id'],
          name: json['user']['name'],
          image: json['user']['image'],
        ));
  }
  @override
  toString() => 'post: $body ' 'image:$image ' 'user:${user!.id} ';
}
