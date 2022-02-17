import 'package:flutter/material.dart';
import 'package:flutter_api_test/constant.dart';
import 'package:flutter_api_test/models/api_response.dart';
import 'package:flutter_api_test/models/comment.dart';
import 'package:flutter_api_test/screens/edit_comment.dart';
import 'package:flutter_api_test/services/comment_service.dart';
import 'package:flutter_api_test/services/user_service.dart';

import 'login.dart';

class CommentScreen extends StatefulWidget {
  final int id;
  const CommentScreen({Key? key, required this.id}) : super(key: key);

  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  List<dynamic> _commentsList = [];
  bool _loading = true;
  int userId = 0;
  TextEditingController _txtCommentController = TextEditingController();

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

  void _createComment() async {
    ApiResponse response =
        await createComment(widget.id, _txtCommentController.text);
    if (response.error == null) {
      _txtCommentController.clear();
      retrieveComments();
    } else if (response.error == unauthorized) {
      logout().then((value) => {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const Login()),
                (route) => false)
          });
    } else {
      setState(() {
        _loading = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }

  @override
  void initState() {
    retrieveComments();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Comments",
            style: robotoTextstyle(),
          ),
        ),
        body: _loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () {
                        return retrieveComments();
                      },
                      child: ListView.builder(
                        itemBuilder: (BuildContext context, int index) {
                          Comment comment = _commentsList[index];
                          return Container(
                            padding: EdgeInsets.all(10),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: Colors.black26, width: 0.5))),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          '${comment.user!.name}',
                                          style: TextStyle(
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
                                                            EditComment()))
                                                    .then((value) => {
                                                          _loading = false,
                                                          retrieveComments(),
                                                          // Provider.of<PostData>(
                                                          //         context)
                                                          //     .retrievePs()
                                                        });
                                              } else {}
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
                                  height: 10,
                                ),
                                Text('${comment.comment}')
                              ],
                            ),
                          );
                        },
                        itemCount: _commentsList.length,
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        border: Border(top: BorderSide(color: Colors.black26))),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            decoration: kinputDecoration('Comment'),
                            controller: _txtCommentController,
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              if (_txtCommentController.text.isNotEmpty) {
                                setState(() {
                                  _loading = true;
                                });
                                _createComment();
                              }
                              FocusScope.of(context).unfocus();
                            },
                            icon: Icon(Icons.send))
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
