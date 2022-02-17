import 'package:flutter/material.dart';
import 'package:flutter_api_test/models/api_response.dart';
import 'package:flutter_api_test/models/comment.dart';
import 'package:flutter_api_test/models/post_data.dart';
import 'package:flutter_api_test/models/user.dart';
import 'package:flutter_api_test/models/post.dart';
import 'package:flutter_api_test/services/comment_service.dart';
import 'package:flutter_api_test/services/post_service.dart';
import 'package:flutter_api_test/services/user_service.dart';
import 'package:provider/provider.dart';

import '../constant.dart';
import 'comment_screen.dart';
import 'edit_comment.dart';
import 'edit_post.dart';
import 'login.dart';

class DetailPost extends StatefulWidget {
  final Post post;
  final int index;
  final bool selflike;
  final int id;
  const DetailPost(
      {Key? key,
      required this.post,
      required this.index,
      required this.id,
      required this.selflike})
      : super(key: key);

  @override
  _DetailPostState createState() => _DetailPostState();
}

class _DetailPostState extends State<DetailPost> {
  int userId = 0;
  bool like = false;
  bool _loading = true;
  dynamic img;

  List<dynamic> _commentsList = [];

  Future<void> retrieveComments() async {
    userId = await getUserId();
    ApiResponse response = await getComments(widget.id);
    if (response.error == null) {
      setState(() {
        _commentsList = response.data as List<dynamic>;

        _loading = _loading ? !_loading : _loading;
        print(_commentsList);
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

  _handleLikeDisLike(int postId) async {
    ApiResponse response = await likeUnlikePost(postId);
    if (response.error == null) {
      setState(() {
        like = !like;
      });
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

  void _handleDeletePost(int postId) async {
    ApiResponse response = await deletePost(postId);
    if (response.error == null) {
      Navigator.pop(context);
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

  Future<void> getUser() async {
    userId = await getUserId();

    setState(() {
      //print(userId);
    });
  }

  @override
  void initState() {
    like = widget.selflike;
    //final _postID = widget.post.id;
    setState(() {});
    if (widget.post.image != null) {
      //wdiget.post.image
      //print(widget.post.image);
      img = const NetworkImage('https://picsum.photos/250?image=9');
    }
    super.initState();
    retrieveComments();
    getUser();

    //print(userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Post"),
        actions: [
          widget.post.user!.id == userId
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
                              builder: (context) => EditPost(post: widget.post
                                  // Provider.of<PostData>(context)
                                  //     .posts[widget.index],
                                  )))
                          .then((value) => {
                                _loading = false,
                                Provider.of<PostData>(context, listen: false)
                                    .retrievePs(),
                                Provider.of<PostData>(context, listen: false)
                                    .getPost,
                                print(widget.post.body)
                              });
                    } else {
                      _handleDeletePost(widget.post.id ?? 0);
                    }
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Icon(
                      Icons.more_vert,
                      color: Colors.white,
                    ),
                  ),
                )
              : const SizedBox()
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                width: double.infinity,
                height: 260,
                child: Hero(
                  tag: img == null
                      ? "https://picsum.photos/250?image=9"
                      : "${widget.post.image}",
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                      image: img == null
                          ? const NetworkImage("https://picsum.photos/250?image=9")
                          : NetworkImage(
                              // "${Provider.of<PostData>(context).posts[widget.index].image}"
                              "${widget.post.image}"),
                      fit: BoxFit.cover,
                    )),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Column(
                  children: <Widget>[
                    Container(
                      alignment: const Alignment(-1.0, -1.0),
                      child: const Padding(
                        padding: EdgeInsets.only(top: 15, bottom: 15),
                        child: Text(
                          'Author',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 24,
                              fontWeight: FontWeight.w300),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(right: 10.0),
                                child: Text(
                                  '${widget.post.user!.name}',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: <Widget>[
                        Center(
                            //alignment: Alignment(-1.0, -1.0),
                            child: const Padding(
                          padding: EdgeInsets.only(bottom: 10.0),
                          child: Text(
                            'Description',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.w300),
                          ),
                        )),
                        Container(
                          alignment: const Alignment(-1.0, -1.0),
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: Text(
                              "${widget.post.body}",
                              //"${Provider.of<PostData>(context).posts[widget.index].body}",
                              style:
                                  const TextStyle(color: Colors.black, fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Divider(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 2, bottom: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _handleLikeDisLike(widget.id);
                      },
                      child: Icon(
                        Icons.thumb_up,
                        color: like == true ? Colors.red : Colors.black,
                      ),
                    ),
                    // Text("${post.likesCount}"),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(
                                builder: (context) => CommentScreen(
                                      id: widget.id,
                                    )))
                            .then((value) =>
                                {_loading = false, retrieveComments()});
                      },
                      child: const Icon(Icons.comment_sharp),
                    )
                  ],
                ),
              ),

              _loading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Column(
                      children: [
                        Column(
                          children: [
                            ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, int index) {
                                Comment comment = _commentsList[index];
                                return Container(
                                  padding: const EdgeInsets.all(10),
                                  width: MediaQuery.of(context).size.width,
                                  decoration: const BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colors.black26,
                                              width: 0.5))),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              // Container(
                                              //   width: 30,
                                              //   height: 30,
                                              //   decoration: BoxDecoration(
                                              //       image: comment.user!.image != null
                                              //           ? DecorationImage(
                                              //               image: NetworkImage(
                                              //                   '${comment.user!.image}'),
                                              //               fit: BoxFit.cover)
                                              //           : null),
                                              // ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                '${comment.user!.name}',
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 16),
                                              )
                                            ],
                                          ),
                                          comment.user!.id == userId
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
                                                              builder: (context) =>
                                                                  const EditComment()))
                                                          .then((value) => {
                                                                _loading =
                                                                    false,
                                                                retrieveComments(),
                                                                // Provider.of<PostData>(
                                                                //         context)
                                                                //     .retrievePs()
                                                              });
                                                    } else {}
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
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text('${comment.comment}')
                                    ],
                                  ),
                                );
                              },
                              itemCount: _commentsList.length,
                            ),
                          ],
                        )
                      ],
                    ),
              // Here commebnts
            ],
          ),
        ),
      ),
    );
  }
}
