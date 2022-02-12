import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_api_test/models/post.dart';
import 'package:flutter_api_test/screens/login.dart';
import 'package:flutter_api_test/services/post_service.dart';
import 'package:flutter_api_test/services/user_service.dart';

import '../constant.dart';
import 'api_response.dart';

class PostData extends ChangeNotifier {
  int userId = 0;
  String query = "";
  List<dynamic> posts = [];
  List<Post> newposts = [];
  var allpost = [];
  dynamic sposts;

  dynamic error;
  Future<void> retrievePs() async {
    userId = await getUserId();
    ApiResponse response = await getPosts(query);
    if (response.error == null) {
      posts = response.data as List<dynamic>;
      //print(response.data);
      //var data = jsonDecode(response.data);
      for (var p in posts) {
        newposts.add(p);
      }

      print(newposts);

      // for (var i = 1; i == allpost.length; i++) {
      //   allpost.add(Post(body: posts[i].body));
      // }
      // for (var p in posts) {
      //   allpost.add(Post(body: p.body, id: p.id, image: p.image, user: p.user));
      // }
      //print(allpost);

      //print(posts);
      notifyListeners();
    } else if (response.error == unauthorized) {
      error = response.error;
    }
  }

  get getPost {
    retrievePs();
    notifyListeners();

    return posts;
  }

  updatepost() {
    retrievePs();
    notifyListeners();
  }
}
