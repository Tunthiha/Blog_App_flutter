import 'package:flutter/material.dart';
import 'package:flutter_api_test/models/api_response.dart';
import 'package:flutter_api_test/models/post.dart';
import 'package:flutter_api_test/models/user.dart';
import 'package:flutter_api_test/services/post_service.dart';
import 'package:flutter_api_test/services/user_service.dart';

import '../constant.dart';
import 'comment_screen.dart';
import 'detail_post.dart';
import 'edit_post.dart';
import 'login.dart';

class BookMark extends StatefulWidget {
  const BookMark({Key? key}) : super(key: key);

  @override
  State<BookMark> createState() => _BookMarkState();
}

class _BookMarkState extends State<BookMark> {
  List<dynamic> _postList = [];
  User? user;
  // List<dynamic> _demo = [];
  String fristHalf = "";
  String SecondHalf = "";
  int userId = 0;
  bool _loading = true;

  void _handleDeletePost(int postId) async {
    ApiResponse response = await deletePost(postId);
    if (response.error == null) {
      retrievePosts(user?.name);
    } else if (response.error == unauthorized) {
      logout().then((value) => {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const Login()),
                (route) => false)
          });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }

  textLength(String text) {
    if (text.length > 50) {
      fristHalf = text.substring(50, text.length);
      SecondHalf = "...";
    } else {
      fristHalf = text;
      SecondHalf = "";
    }
  }

  Future<void> retrievePosts(user) async {
    userId = await getUserId();
    ApiResponse response = await bookmarkPosts("hello");
    if (response.error == null) {
      setState(() {
        _postList = response.data as List<dynamic>;
        print(_postList);

        _loading = _loading ? !_loading : _loading;
        // Provider.of<PostData>(context, listen: false).posts =
        //     response.data as List<dynamic>;

        //print(_demo);
      });
    } else if (response.error == unauthorized) {
      logout().then((value) => {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const Login()),
                (route) => false)
          });
    }
  }

  retreiveUserDetail() async {
    ApiResponse response = await getUserDetail();
    if (response.error == null) {
      setState(() {
        user = response.data as User;
        _loading = _loading ? !_loading : _loading;
        //print(user!.name);
        //retrievePosts(user!.name);
      });
    } else if (response.error == unauthorized) {
      logout().then((value) => {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const Login()),
                (route) => false)
          });
    }
  }

  @override
  void initState() {
    retreiveUserDetail();
    retrievePosts(user?.name);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "BookMark",
          style: robotoTextstyle(),
        ),
      ),
      drawer: SafeArea(
        child: Navigation(
          user: user,
          selectedNav: 3,
        ),
      ),
      body: Column(
        children: [
          Flexible(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: () {
                      return retrievePosts(user?.name);
                    },
                    child: ListView.builder(
                      padding: EdgeInsets.only(bottom: 58),
                      itemBuilder: (BuildContext context, int index) {
                        Post post = _postList[index];
                        // Post newpost =
                        //     Provider.of<PostData>(context).newposts[index];

                        textLength(post.body ?? "");
                        return Padding(
                          padding: const EdgeInsets.only(
                              left: 4, right: 4, top: 3, bottom: 3),
                          child: InkWell(
                            customBorder: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            )),
                            onTap: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(
                                      builder: (context) => DetailPost(
                                            post: post,
                                            selflike: post.selfLiked ?? false,
                                            index: index,
                                            id: post.id ?? 0,
                                          )))
                                  .then((value) => {
                                        _loading = false,
                                        retrievePosts(user?.name)
                                      });
                            },
                            child: Card(
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                              )),
                              elevation: 5,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 0, vertical: 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    post.image == null
                                        ? Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: 180,
                                            decoration: const BoxDecoration(
                                                image: DecorationImage(
                                                    image: NetworkImage(
                                                        'https://picsum.photos/250?image=9'),
                                                    fit: BoxFit.fill)),
                                          )
                                        : Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: 180,
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                              image:
                                                  NetworkImage('${post.image}'),
                                              //'https://picsum.photos/250?image=9'),
                                              fit: BoxFit.fill,
                                            )),
                                          ),

                                    const SizedBox(
                                      height: 10,
                                    ),

                                    Row(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 5),
                                              child: Container(
                                                child: Text(
                                                  "${post.user!.name}",
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const Spacer(),
                                        post.user!.id == userId
                                            ? PopupMenuButton(
                                                itemBuilder: (context) => [
                                                  const PopupMenuItem(
                                                    child: Text(
                                                      'Edit',
                                                    ),
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
                                                            builder:
                                                                (context) =>
                                                                    EditPost(
                                                                      post:
                                                                          post,
                                                                    )))
                                                        .then((value) => {
                                                              _loading = false,
                                                              retrievePosts(
                                                                  user?.name),
                                                              // Provider.of<PostData>(
                                                              //         context)
                                                              //     .retrievePs()
                                                            });
                                                  } else {
                                                    _handleDeletePost(
                                                        post.id ?? 0);
                                                  }
                                                },
                                                child: const Padding(
                                                  padding: EdgeInsets.only(
                                                      right: 10),
                                                  child: Icon(
                                                    Icons.more_vert,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              )
                                            : const SizedBox()
                                      ],
                                    ),

                                    // Text(
                                    //   '${post.body}',
                                    //   maxLines: 2,
                                    // ),

                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Wrap(
                                        children: [
                                          Text(
                                            "${post.body}",
                                            maxLines: 2,
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w200),
                                          ),
                                          // TextButton(
                                          //     onPressed: () {
                                          //       print(_postList[index]);
                                          //     },
                                          //     child: Text("hello")),

                                          // Container(
                                          //   child: Text("${newpost.body}"),
                                          // )
                                        ],
                                      ),
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 2, bottom: 0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              //_handleLikeDisLike(post.id ?? 0);
                                            },
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.thumb_up,
                                                  color: Colors.black,
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text('${post.likesCount ?? 0}')
                                              ],
                                            ),
                                          ),
                                          // Text("${post.likesCount}"),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          CommentScreen(
                                                            id: post.id ?? 0,
                                                          )));
                                            },
                                            child: Row(
                                              children: [
                                                Icon(Icons.comment_sharp),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text('${post.commentsCount}')
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      itemCount: _postList.length,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
