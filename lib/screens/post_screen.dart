import 'package:flutter/material.dart';
import 'package:flutter_api_test/models/api_response.dart';
import 'package:flutter_api_test/models/post.dart';
import 'package:flutter_api_test/screens/detail_post.dart';
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

  @override
  void initState() {
    retrievePosts();
    //print(userId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
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
      body: Container(
        child: Column(
          children: [
            Row(
              children: [
                Flexible(
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Color(0xFFECECEC)),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 13, bottom: 8),
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
                            hintText: 'Search here',
                            icon: Padding(
                              padding: const EdgeInsets.only(
                                  right: 0, left: 0, top: 11),
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
                Padding(
                  padding: const EdgeInsets.only(right: 5, left: 5, top: 10),
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () async {
                      setState(() {
                        _loading = true;
                        _searchController.text = "";
                        query = "";
                        retrievePosts();
                        FocusScope.of(context).unfocus();
                      });
                    },
                  ),
                )
              ],
            ),
            SizedBox(
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
                        itemBuilder: (BuildContext context, int index) {
                          Post post = _postList[index];
                          textLength(post.body ?? "");
                          return InkWell(
                            child: Card(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 4, vertical: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
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
                                                              retrievePosts()
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
                                    Divider(
                                      color: Colors.black,
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
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
                                                    fit: BoxFit.cover)),
                                          ),

                                    // Text(
                                    //   '${post.body}',
                                    //   maxLines: 2,
                                    // ),
                                    Divider(
                                      color: Colors.black,
                                      height: 4,
                                    ),
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
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w200),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: const [
                                              Text(
                                                'More Detail',
                                                style: TextStyle(
                                                    color: Color(0xFF3f37cc)),
                                              ),
                                              Icon(Icons.arrow_right)
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              elevation: 5,
                            ),
                            onTap: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(
                                      builder: (context) => DetailPost(
                                            post: post,
                                          )))
                                  .then((value) =>
                                      {_loading = false, retrievePosts()});
                            },
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
