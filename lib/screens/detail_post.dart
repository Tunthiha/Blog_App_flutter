import 'package:flutter/material.dart';
import 'package:flutter_api_test/models/api_response.dart';
import 'package:flutter_api_test/models/post_data.dart';
import 'package:flutter_api_test/models/user.dart';
import 'package:flutter_api_test/models/post.dart';
import 'package:flutter_api_test/services/post_service.dart';
import 'package:flutter_api_test/services/user_service.dart';
import 'package:provider/provider.dart';

import '../constant.dart';
import 'edit_post.dart';
import 'login.dart';

class DetailPost extends StatefulWidget {
  final Post post;
  final int index;

  const DetailPost({Key? key, required this.post, required this.index})
      : super(key: key);

  @override
  _DetailPostState createState() => _DetailPostState();
}

class _DetailPostState extends State<DetailPost> {
  int userId = 0;

  bool _loading = true;
  dynamic img;
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
    //final _postID = widget.post.id;
    setState(() {});
    if (widget.post.image != null) {
      //wdiget.post.image
      //print(widget.post.image);
      img = NetworkImage('https://picsum.photos/250?image=9');
    }
    super.initState();
    getUser();

    //print(userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail Post"),
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
              : SizedBox()
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
                          ? NetworkImage("https://picsum.photos/250?image=9")
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
                      alignment: Alignment(-1.0, -1.0),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 15, bottom: 15),
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
                                  style: TextStyle(
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
                            child: Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Text(
                            'Description',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.w300),
                          ),
                        )),
                        Container(
                          alignment: Alignment(-1.0, -1.0),
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: Text(
                              "${widget.post.body}",
                              //"${Provider.of<PostData>(context).posts[widget.index].body}",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
