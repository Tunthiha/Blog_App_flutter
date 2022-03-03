import 'package:flutter/material.dart';
import 'package:flutter_api_test/models/api_response.dart';
import 'package:flutter_api_test/models/post.dart';
import 'package:flutter_api_test/models/post_data.dart';
import 'package:flutter_api_test/models/user.dart';
import 'package:flutter_api_test/screens/comment_screen.dart';
import 'package:flutter_api_test/screens/detail_post.dart';
import 'package:flutter_api_test/screens/edit_post.dart';
import 'package:flutter_api_test/screens/post_form.dart';
import 'package:flutter_api_test/screens/profile_screen.dart';
import 'package:flutter_api_test/services/post_service.dart';
import 'package:flutter_api_test/services/user_service.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:flutter_api_test/models/post.dart';

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
  User? user;
  // List<dynamic> _demo = [];
  String fristHalf = "";
  String SecondHalf = "";
  int userId = 0;
  bool _loading = true;
  String query = "";
  bool flag = true;

  textLength(String text) {
    if (text.length > 50) {
      fristHalf = text.substring(50, text.length);
      SecondHalf = "...";
    } else {
      fristHalf = text;
      SecondHalf = "";
    }
  }

  Future<void> getPost() async {
    setState(() {
      Provider.of<PostData>(context, listen: false).retrievePs();
    });
  }

  Future<void> retrievePosts() async {
    userId = await getUserId();
    ApiResponse response = await getPosts(query);
    if (response.error == null) {
      setState(() {
        _postList = response.data as List<dynamic>;

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

  void _handleDeletePost(int postId) async {
    ApiResponse response = await deletePost(postId);
    if (response.error == null) {
      retrievePosts();
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

  _handleLikeDisLike(int postId) async {
    ApiResponse response = await likeUnlikePost(postId);
    if (response.error == null) {
      retrievePosts();
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

  @override
  void initState() {
    retrievePosts();
    //print(userId);
    super.initState();
    //getPost();
    // _demo = Provider.of<PostData>(context, listen: false).getPost;
    // print(_demo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 0, bottom: 0),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => const PostForm()))
                .then((value) => {_loading = false, retrievePosts()});
          },
          child: const Icon(
            Icons.post_add,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 10),
        child: Column(
          children: [
            Row(
              children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: const Color(0xFFECECEC)),
                      child: Padding(
                        padding:
                            const EdgeInsets.only(right: 15, bottom: 0, top: 0),
                        child: TextFormField(
                          controller: _searchController,
                          onFieldSubmitted: (_) {
                            setState(() {
                              query = _searchController.text;
                              _loading = true;
                              retrievePosts();
                            });
                          },
                          autofocus: false,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () async {
                                  setState(() {
                                    _loading = true;
                                    query = "";
                                    FocusScope.of(context).unfocus();
                                    retrievePosts();
                                    _searchController.text = "";
                                  });
                                },
                              ),
                              hintText: 'Search here',
                              icon: Padding(
                                padding: const EdgeInsets.only(
                                    right: 0, left: 0, top: 0),
                                child: IconButton(
                                    onPressed: () async {
                                      setState(() {
                                        query = _searchController.text;
                                        _loading = true;
                                        retrievePosts();
                                        FocusScope.of(context).unfocus();
                                      });
                                    },
                                    icon: const Icon(Icons.search)),
                              )),
                        ),
                      ),
                    ),
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.only(right: 5, left: 5, top: 10),
                //   child: IconButton(
                //     icon: const Icon(Icons.close),
                //     onPressed: () async {
                //       setState(() {
                //         _loading = true;
                //         _searchController.text = "";
                //         query = "";
                //         retrievePosts();
                //         FocusScope.of(context).unfocus();
                //       });
                //     },
                //   ),
                // )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Flexible(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : RefreshIndicator(
                      onRefresh: () {
                        _searchController.text = "";
                        query = "";
                        return retrievePosts();
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
                                    .then((value) =>
                                        {_loading = false, retrievePosts()});
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                                image: NetworkImage(
                                                    '${post.image}'),
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
                                                child: Row(
                                                  children: [
                                                    Icon(Icons.account_box),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text(
                                                      "${post.user!.name}",
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18),
                                                    ),
                                                  ],
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
                                                          .push(
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          EditPost(
                                                                            post:
                                                                                post,
                                                                          )))
                                                          .then((value) => {
                                                                _loading =
                                                                    false,
                                                                retrievePosts(),
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
                                        child: Text(
                                          "${post.body}",
                                          maxLines: 2,
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w200),
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
                                                _handleLikeDisLike(
                                                    post.id ?? 0);
                                              },
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.thumb_up,
                                                    color:
                                                        post.selfLiked == true
                                                            ? Colors.blueAccent
                                                            : Colors.black,
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                      '${post.likesCount ?? 0}')
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
            )
          ],
        ),
      ),
    );
  }
}
