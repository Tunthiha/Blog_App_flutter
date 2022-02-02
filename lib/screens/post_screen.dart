import 'package:flutter/material.dart';
import 'package:flutter_api_test/models/api_response.dart';
import 'package:flutter_api_test/models/post.dart';
import 'package:flutter_api_test/screens/edit_post.dart';
import 'package:flutter_api_test/screens/post_form.dart';
import 'package:flutter_api_test/screens/profile_screen.dart';
import 'package:flutter_api_test/services/post_service.dart';
import 'package:flutter_api_test/services/user_service.dart';

import '../constant.dart';
import 'login.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({Key? key}) : super(key: key);

  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _postList = [];
  int userId = 0;
  bool _loading = true;
  String query = "";

  Future<void> retrievePosts() async {
    userId = await getUserId();
    ApiResponse response = await getPosts(query);
    if (response.error == null) {
      setState(() {
        _postList = response.data as List<dynamic>;
        _loading = _loading ? !_loading : _loading;
      });
    } else if (response.error == unauthorized) {
      logout().then((value) => {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => Login()),
                (route) => false)
          });
    }
  }

  void _handleDeletePost(int postId) async {
    ApiResponse response = await deletePost(postId);
    if (response.error == null) {
      retrievePosts();
    } else if (response.error == unauthorized) {
      logout().then((value) => {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => Login()),
                (route) => false)
          });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }

  @override
  void initState() {
    retrievePosts();
    print(userId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => PostForm()))
              .then((value) => {_loading = false, retrievePosts()});
        },
        child: Icon(Icons.post_add),
      ),
      body: Container(
        child: Column(
          children: [
            Row(
              children: [
                Flexible(
                  child: TextFormField(
                    controller: _searchController,
                    onFieldSubmitted: (_) {
                      //print("hello");
                    },
                    autofocus: false,
                    decoration: InputDecoration(
                        hintText: 'Search here',
                        icon: IconButton(
                            onPressed: () {
                              setState(() {
                                // query = _searchController.text;
                                // _loading = true;
                                // retrievePosts();
                              });
                            },
                            icon: const Icon(Icons.search))),
                  ),
                ),
              ],
            ),
            Flexible(
              child: _loading
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemBuilder: (BuildContext context, int index) {
                        Post post = _postList[index];
                        return Card(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 4, vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 1),
                                          child: Container(
                                            child: Text(
                                              "${post.user!.name}",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Spacer(),
                                    post.user!.id == userId
                                        ? PopupMenuButton(
                                            itemBuilder: (context) => [
                                              const PopupMenuItem(
                                                child: Text('Edit'),
                                                value: 'edit',
                                              ),
                                              const PopupMenuItem(
                                                child: Text('Delete'),
                                                value: 'delete',
                                              )
                                            ],
                                            onSelected: (value) {
                                              if (value == 'edit') {
                                                Navigator.of(context)
                                                    .push(MaterialPageRoute(
                                                        builder: (context) =>
                                                            EditPost(
                                                              post: post,
                                                            )))
                                                    .then((value) => {
                                                          _loading = false,
                                                          retrievePosts()
                                                        });
                                              } else {
                                                _handleDeletePost(post.id ?? 0);
                                              }
                                            },
                                            child: const Padding(
                                              padding:
                                                  EdgeInsets.only(right: 10),
                                              child: Icon(
                                                Icons.more_vert,
                                                color: Colors.black,
                                              ),
                                            ),
                                          )
                                        : SizedBox()
                                  ],
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Text('${post.body}'),
                                SizedBox(
                                  height: 10,
                                ),
                                post.image == null
                                    ? Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 180,
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                    'https://picsum.photos/250?image=9'),
                                                fit: BoxFit.cover)),
                                      )
                                    : Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 180,
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                    'https://picsum.photos/250?image=9'),
                                                fit: BoxFit.cover)),
                                      )
                              ],
                            ),
                          ),
                        );
                      },
                      itemCount: _postList.length,
                    ),
            )
          ],
        ),
      ),
    );
  }
}
